extends Node2D
class_name Enemy


enum IntentState {
	ATTACK,
	DEFENSE,
	BUFF,
	DEBUFF,
	ATTACK_BUFF,
	ATTACK_DEBUFF,
	HEAL,
	CURSE,
	UNKNOWN,
	DEATH
}

enum BehaviorMode {
	SEQUENTIAL,
	RANDOM,
	CUSTOM,
	CHANCE_BASED
}


var max_health = 100:
	set(value):
		max_health = value
		update_hp_bar()

var health = 100:
	set(value):
		health = clamp(value, 0, max_health)
		update_hp_bar()

var block = 0:
	set(value):
		block = value
		update_hp_bar()
		

		
var bonus_damage = 0
var damage_mult = 1
var incoming_damage_mult = 1

var statuses = []

var behavior_mode = BehaviorMode.SEQUENTIAL

var actions = []
var current_action_index = -1
var last_action_index = -1
var repeat_counter = 0

var first_turn_done = false
var first_action_index = -1

var custom_action_sequence = []
var custom_action_index = 0

var intent_state = IntentState.UNKNOWN
var intent_damage = 0

var will_attack = true #Переменная для ActionManager, которая говорит будет ли враг в свой ход двигаться
var is_dead = false


@onready var hp_bar = $HpBar
@onready var hp_bar_label = $HpBar/HpBarLabel
@onready var sprite = $AnimatedSprite2D
@onready var aim_marker = $AimMarker
@onready var status_container = $StatusContainer

@onready var intent_icon = $IntentIcon
@onready var damage_label = $IntentIcon/DamageLabel
@onready var block_icon = $HpBar/ArmorIcon
@onready var block_label = $HpBar/ArmorIcon/ArmorLabel


func _ready():

	health = max_health
	Global.enemy = self

	update_hp_bar()

	intent_icon_animation()
	
	Signals.enemy_turn_begin.connect(remove_block)

func remove_block():
	block = 0

func update_hp_bar():

	hp_bar_label.text = str(health) + "/" + str(max_health)
	hp_bar.max_value = max_health
	hp_bar.value = health
	
	if block > 0:
		block_icon.visible = true
		block_label.text = str(block)
	else:
		block_icon.visible = false
	



func final_damage(damage):
	return ActionManager.calculate_damage(self, Global.hero, damage)



func take_damage(damage):

	if is_dead:
		return

	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color(2,2,2,1), 0.05)
	tween.tween_property(sprite, "modulate", Color(1,1,1,1), 0.05)
	
	
	if block > damage:
		block -= damage
		damage = 0
	else: 
		damage -= block
		block = 0
	health -= damage

	if health <= 0:
		dead()


func take_heal(heal):
	health += heal
	
func take_block(armor):
	block += armor



func dead():

	is_dead = true
	Signals.enemy_dead.emit()
	

	
	self.set_physics_process(false)
	var tween = get_tree().create_tween()
	tween.tween_property(self,"modulate", Color(0,0,0,0), 1)
	#queue_free()



func intent_icon_animation():

	var start_pos = intent_icon.position.y
	var move_distance = 3
	var duration = 0.7

	var tween = create_tween()
	tween.set_loops()

	tween.tween_property(intent_icon,"position:y",start_pos + move_distance,duration).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(intent_icon,"position:y",start_pos,duration).set_ease(Tween.EASE_IN_OUT)



func update_intent_icon():

	match intent_state:

		IntentState.ATTACK:
			intent_icon.texture = load("res://assets/Icons/IntentIcons/AttackIcon3.png")
			damage_label.visible = true
			will_attack = true

		IntentState.DEFENSE:
			intent_icon.texture = load("res://assets/IntentIcons/DefenseIcon.png")
			damage_label.visible = false
			will_attack = false

		IntentState.BUFF:
			intent_icon.texture = load("res://assets/Icons/IntentIcons/Buff3.png")
			damage_label.visible = false
			will_attack = false

		IntentState.DEBUFF:
			intent_icon.texture = load("res://assets/Icons/IntentIcons/Debuff3.png")
			damage_label.visible = false
			will_attack = false

		IntentState.ATTACK_BUFF:
			intent_icon.texture = load("res://assets/Icons/IntentIcons/AttackBuff.png")
			damage_label.visible = true
			will_attack = true

		IntentState.ATTACK_DEBUFF:
			intent_icon.texture = load("res://assets/Icons/IntentIcons/AttackDebuff3.png")
			damage_label.visible = true
			will_attack = true

		IntentState.HEAL:
			intent_icon.texture = load("res://assets/IntentIcons/HealIcon.png")
			damage_label.visible = false
			will_attack = false

		IntentState.CURSE:
			intent_icon.texture = load("res://assets/IntentIcons/CurseIcon.png")
			damage_label.visible = false
			will_attack = false

		IntentState.UNKNOWN:
			intent_icon.texture = load("res://assets/IntentIcons/UnknownIcon.png")
			damage_label.visible = false
			will_attack = false



func plan_next_action():

	match behavior_mode:

		BehaviorMode.SEQUENTIAL:
			current_action_index = (current_action_index + 1) % actions.size()

		BehaviorMode.RANDOM:
			current_action_index = randi() % actions.size()

		BehaviorMode.CUSTOM:

			if custom_action_sequence.is_empty():
				return

			current_action_index = custom_action_sequence[custom_action_index]
			custom_action_index = (custom_action_index + 1) % custom_action_sequence.size()

		BehaviorMode.CHANCE_BASED:

			if not first_turn_done:

				if first_action_index >= 0:
					current_action_index = first_action_index
				else:
					current_action_index = randi() % actions.size()

				first_turn_done = true

			else:

				var valid_actions = []

				for i in range(actions.size()):

					var max_r = actions[i].get("max_repeats",1)

					if i == last_action_index and repeat_counter >= max_r:
						continue

					valid_actions.append(i)

				if valid_actions.is_empty():
					valid_actions = range(actions.size())
					repeat_counter = 0

				var total_chance = 0

				for i in valid_actions:
					total_chance += actions[i].get("chance",0)

				var roll = randi() % total_chance
				var running = 0

				for i in valid_actions:

					running += actions[i].get("chance",0)

					if roll < running:
						current_action_index = i
						break

			if current_action_index == last_action_index:
				repeat_counter += 1
			else:
				last_action_index = current_action_index
				repeat_counter = 1



	var action = actions[current_action_index]

	intent_state = action["intent"]

	if action.has("damage"):
		intent_damage = final_damage(action["damage"])
	else:
		intent_damage = 0

	damage_label.text = str(intent_damage)

	update_intent_icon()



func add_action():

	if is_dead:
		return

	var action = actions[current_action_index]

	action["func"].call()

	plan_next_action()
	
	
func attack_animation():

	var old_position = sprite.position

	var tween = get_tree().create_tween()

	tween.tween_property(sprite,"position",sprite.position + Vector2(10,0),0.4)
	tween.tween_property(sprite,"position",sprite.position + Vector2(-30,0),0.2)
	tween.tween_callback(func(): Signals.enemy_attack.emit())
	tween.tween_property(sprite,"position",old_position,0.4)

	await tween.finished
