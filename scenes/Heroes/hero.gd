extends Node2D

var max_health = 100:
	set(value):
		update_hp_bar()
var health = 100:
	set(value):
		health = clamp(value, 0, max_health)
		update_hp_bar()
		
var block = 0:
	set(value):
		block = value
		update_hp_bar()
var bonus_block = 0
		
var damage_mult = 1
var bonus_damage = 0
var incoming_damage_mult = 1

var statuses = []

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
	
func take_damage(damage):
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
	pass
	
