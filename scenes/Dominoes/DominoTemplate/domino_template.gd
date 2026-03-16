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

var domino_types = ["Attack"]


var damage
var block
var heal

var doubled = false

var mouse_over_des = false
var des_tween: Tween

var domino_choice = false
var deleted = false

@onready var top_icons = $Visual/TopIcons
@onready var bot_icons = $Visual/BotIcons
@onready var aim_marker = $AimMarker

@onready var dm_name: String
@onready var description: String = ""
@onready var des_panel = $DesPanel
@onready var des_label = $DesPanel/DesLabel



func _ready() -> void:
	update_labels()
	hide_des_fast()
	


func add_actions():
	if DominoManager.double_next_dm > 0:
		print("DOUBLED")
		add_action()
		domino_played()
		DominoManager.double_next_dm -= 1
		doubled = true
	
	add_action()
	domino_played()
	


func get_status(target, status_id:String):
	for icon in target.status_container.get_children():
		if icon.status.id == status_id:
			return icon.status
	return null


func add_action():
	#ActionManager.add(AttackAction.new(self, Global.enemy, 5))
	#ActionManager.add(AttackDebuffAction.new(self, Global.enemy, 5, StatusManager.weak, 2))
	ActionManager.add(AttackDebuffAction.new(self, Global.enemy, 5, StatusManager.vulnerable, 2))
	#ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.corruption, 5))
	#ActionManager.add(BlockAction.new(self, Global.hero,5))
	
func domino_played():
	for type in domino_types:
		if type == "Attack":
			Signals.attack_dm_played.emit(self)
		if type == "Defense":
			Signals.defense_dm_played.emit(self)
		if type == "Skill":
			Signals.skill_dm_played.emit(self)
			

	if a == 1:
		Signals._1dm_played.emit(self)
		DominoManager.value1_played_dominoes += 1
	if a == 2:
		Signals._2dm_played.emit(self)
		DominoManager.value2_played_dominoes += 1
	if a == 3:
		Signals._3dm_played.emit(self)
		DominoManager.value3_played_dominoes += 1
	if a == 4:
		Signals._4dm_played.emit(self)
		DominoManager.value4_played_dominoes += 1

		

	if b == 1:
		Signals._1dm_played.emit(self)
		if b != a:
			DominoManager.value1_played_dominoes += 1
	if b == 2:
		Signals._2dm_played.emit(self)
		if b != a:
			DominoManager.value2_played_dominoes += 1
	if b == 3:
		Signals._3dm_played.emit(self)
		if b != a:
			DominoManager.value3_played_dominoes += 1
	if b == 4:
		Signals._4dm_played.emit(self)
		if b != a:
			DominoManager.value4_played_dominoes += 1
	
func final_damage(_damage: int):
	var new_damage = ActionManager.calculate_damage(self, Global.enemy,_damage)
	return new_damage

func get_open_value():

	if connected_side == 0:
		return b

	if connected_side == 1:
		return a

	return null
	
func final_block(block):
	return ActionManager.calculate_block(block)



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
			hide_des_fast()
		
			if event.pressed:
				
				
				
				
				if DominoManager.block_domino_input:
					return
				
				if DominoManager.delete_mode:
					if !deleted:
							deleted = true
							remove_from_deck()
							return
					else:
						return
				
				
				
				
				
				if domino_choice:
					if Global.choice_scene.choice_locked:
						return
					Global.choice_scene.choice_selected(self)
					add_domino_to_deck()
					Signals.domino_selected.emit()
					return
					
					
				if slot:
					slot.remove_chain()
					#Hand.add_domino(self)


					
				start_drag()

			else:
				stop_drag()

func add_domino_to_deck():
	var tween = get_tree().create_tween()
	var pos = Vector2(15,300)
	tween.set_parallel()
	tween.tween_property(self, "global_position", pos, 0.5)
	tween.tween_property(self, "scale", Vector2(0,0), 0.5)
	DominoManager.temp_deck.append(self)
	domino_choice = false

func remove_from_deck():
	Signals.domino_deleted_from_deck.emit()
	var tween = get_tree().create_tween()
	tween.set_parallel()

	tween.tween_property(self, "scale", Vector2(0,0), 0.25)
	tween.tween_property(self, "rotation_degrees", 180, 0.25)
	await tween.finished
	DominoManager.temp_deck.erase(self)
	queue_free()



func start_drag():
	DominoManager.dm_dragging = true
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
	DominoManager.dm_dragging = false
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
	mouse_over_des = true
	show_des()


func _on_area_2d_mouse_exited() -> void:
	BoardManager.disable_highlight()
	mouse_over_des = false
	hide_des()
	
func show_des():
	if DominoManager.dm_dragging:
		return
	if dragging:
		return
	update_labels()
	des_panel.visible = true
	
	if des_tween and des_tween.is_running():
		des_tween.kill()
	
	des_tween = get_tree().create_tween()
	des_tween.tween_property(des_panel, "modulate:a", 1, 0.15)

func hide_des():
	if not mouse_over_des: # не скрываем, если курсор снова вернулся
		if des_tween and des_tween.is_running():
			des_tween.kill()
		
		des_tween = get_tree().create_tween()
		des_tween.tween_property(des_panel, "modulate:a", 0, 0.15)
		await des_tween.finished
		if not mouse_over_des:
			des_panel.visible = false
			
func hide_des_fast():
	des_panel.visible = false
			
func update_labels():
	des_label.text = ""
