class_name Domino
extends Node2D
#SSS
@export var a:int
@export var b:int

var target_position:Vector2

var slot:DominoSlot = null
var connected_side := 1

var dragging := false
var returning_to_hand = false
var drag_offset := Vector2.ZERO


var board:BoardManager

var damage
var block
var heal

@onready var top_icons = $Visual/TopIcons
@onready var bot_icons = $Visual/BotIcons
@onready var aim_marker = $AimMarker



func _ready():

	board = BoardManager

func add_action():
	ActionManager.add(AttackAction.new(self, Global.enemy, final_damage(5)))
	#ActionManager.add(AttackDebuffAction.new(self, Global.enemy, final_damage(5), StatusManager.vulnerable, 2))
	#ActionManager.add(BlockAction.new(self, Global.hero,5))
	
func final_damage(_damage: int):
	var new_damage = ActionManager.calculate_damage(self, Global.enemy,_damage)
	print(Global.enemy.incoming_damage_mult)
	return new_damage

func get_open_value():

	if connected_side == 0:
		return b

	if connected_side == 1:
		return a

	return null



func rotate_to_match(required_value:int, dir:int):
	# Определяем какая сторона соединяется с родительским домино
	if a == required_value:
		connected_side = 0
	else:
		connected_side = 1

	var angle = 0

	# Основной угол в зависимости от направления слота
	match dir:
		DominoSlot.Direction.UP:
			angle = 180
		DominoSlot.Direction.DOWN:
			angle = 0
		DominoSlot.Direction.LEFT:
			angle = 90
		DominoSlot.Direction.RIGHT:
			angle = 270

	# Если соединена «вторая сторона», переворачиваем домино на 180°
	if connected_side == 1:
		angle += 180

	rotation_degrees = angle % 360

	# Поворачиваем символы против поворота домино, чтобы они всегда были читаемы
	if top_icons and bot_icons:
		top_icons.rotation_degrees = -rotation_degrees
		bot_icons.rotation_degrees = -rotation_degrees
		
func reset_rotation():
	# Сбрасываем основное вращение домино
	rotation_degrees = 0
	# Сбрасываем вращение иконок
	if top_icons:
		top_icons.rotation_degrees = 0
	if bot_icons:
		bot_icons.rotation_degrees = 0




func _on_area_2d_input_event(_viewport, event, _shape):

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT:
		
			if event.pressed:
				if slot:
					slot.remove_chain()
					#Hand.add_domino(self)


					
				start_drag()

			else:
				stop_drag()



func start_drag():
	print("DRAAAG")
	if returning_to_hand:
		return



	dragging = true

	Hand.remove_domino(self)

	drag_offset = global_position - get_global_mouse_position()

	z_index = 100

	if slot:
		slot.remove_chain()
		






func _process(_delta):
	if dragging and slot == null:
		global_position = get_global_mouse_position() + drag_offset


func stop_drag():
	if not dragging:
		return

	var target_slot = BoardManager.target_slot

  # Отключаем drag первым делом

	if target_slot and target_slot.can_place(self):
		target_slot.place_domino(self)
	else:
		Hand.add_domino(self)
		
	dragging = false

	z_index = 0



func move_to_hand(pos:Vector2):
	returning_to_hand = true
	reset_rotation()
	
	var tween = create_tween()
	
	#stop_drag()
	
	tween.tween_property(
		self,
		"global_position",
		Hand.global_position + pos,
		0.3
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	
	await tween.finished
	returning_to_hand = false
	
func play_anim():
	z_index = 100
	var tween = create_tween()
	tween.parallel()
	tween.tween_property(self, "scale", Vector2(1.4, 1.4), 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished
	z_index = 0

func _on_area_2d_mouse_entered() -> void:
	if slot:
		return
	BoardManager.highlight_avaiable_slots([a,b])


func _on_area_2d_mouse_exited() -> void:
	BoardManager.disable_highlight()
