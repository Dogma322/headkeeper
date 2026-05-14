extends Node2D
class_name Hero

var max_health = 100:
	set(value):
		max_health = value
		update_hp_bar()
		Signals.hero_health_changed.emit()

var health = 100:
	set(value):
		health = clamp(value, 0, max_health)
		update_hp_bar()
		Signals.hero_health_changed.emit()

var block = 0:
	set(value):
		block = value
		update_hp_bar()

var bonus_block = 0
var damage_mult = 1
var bonus_damage = 0
var incoming_damage_mult = 1
var thorns_damage_mult := 1
var domino_ignore_count := 0
var is_dead := false

var base_sprite_position
var damage_tween: Tween

@onready var hp_bar = $HpBar
@onready var sprite = $AnimatedSprite2D
@onready var hp_bar_label = $HpBar/HpBarLabel
@onready var aim_marker = $AimMarker
@onready var status_container = $StatusContainer
@onready var block_icon = $HpBar/ArmorIcon
@onready var block_label = $HpBar/ArmorIcon/ArmorLabel


func _ready() -> void:
	Global.hero = self
	update_hp_bar()
	Signals.player_turn_begin.connect(remove_block)
	Signals.enemy_dead.connect(remove_block)
	Signals.reset_run_data.connect(reset)
	
	base_sprite_position = sprite.position


func reset() -> void:
	max_health = 100
	health = 100
	block = 0
	bonus_block = 0
	damage_mult = 1
	bonus_damage = 0
	incoming_damage_mult = 1
	thorns_damage_mult = 1
	domino_ignore_count = 0
	is_dead = false


func remove_block() -> void:
	block = 0


func update_hp_bar() -> void:
	hp_bar_label.text = str(health) + "/" + str(max_health)
	hp_bar.max_value = max_health
	hp_bar.value = health
	
	if block > 0:
		block_icon.visible = true
		block_label.text = str(block)
	else:
		block_icon.visible = false
		
	if max_health <= 0:
		dead()


func take_damage(damage: int) -> void:
	take_damage_anim()
	if is_dead:
		return
	
	var invincible_status = get_status("invincible")
	if invincible_status and invincible_status.stacks > 0:
		damage = 0

	var evasion_status = get_status("evasion")
	if evasion_status and evasion_status.stacks > 0:
		evasion_status.stacks -= 1
		damage = 0
	
	if block > damage:
		block -= damage
		damage = 0
	else: 
		damage -= block
		block = 0
	health -= damage
	
	if damage == 0:
		AnimationManager.spawn_block_label(self)
	else:
		AnimationManager.spawn_damage_label(damage, self)

	if health <= 0:
		dead()


func get_status(status_id: String) -> StatusResource:
	for icon in status_container.get_children():
		if icon.status.id == status_id:
			return icon.status
	return null


func take_damage_anim() -> void:
	if damage_tween:
		damage_tween.kill()

	damage_tween = get_tree().create_tween()

	damage_tween.tween_property(sprite, "position", base_sprite_position + Vector2(2,0), 0.05)
	damage_tween.tween_property(sprite, "position", base_sprite_position + Vector2(-2,0), 0.05)
	damage_tween.tween_property(sprite, "position", base_sprite_position, 0.05)

	sprite.material = preload("res://scenes/WhiteShader/white_shader.tres")
	await get_tree().create_timer(0.1).timeout
	sprite.material = null


func take_heal(heal: int) -> void:
	health += heal


func take_block(armor: int) -> void:
	block += armor


func dead() -> void:
	if is_dead:
		return
	is_dead = true
	var tween = get_tree().create_tween()
	tween.tween_property(self,"modulate", Color(0,0,0,0), 1)
	await get_tree().create_timer(1.5).timeout
	Signals.hero_dead.emit()
