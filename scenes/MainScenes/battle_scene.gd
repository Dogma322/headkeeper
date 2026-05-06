@tool
extends ScreenBase
class_name BattleScene

@onready var characters = $Characters
@onready var play_btn: GameButton = %PlayBtn
@onready var main_buttons_box: VBoxContainer = $MainButtonsBox
@onready var board_1: Board = $Board/Board1
@onready var hand: Node2D = $Hand
@onready var camera: Node2D = $Camera

@onready var heads_ui: VBoxContainer = %HeadsUI

var head_origin := Vector2.ZERO
var random_head: Head = null
var head_buffer: Head = null

var offset:
	get:
		return global_position

func _ready() -> void:
	play_btn.text = tr("play")
	
	if not Engine.is_editor_hint():
		Signals.player_turn_end.connect(_on_player_turn_end)
		Signals.domino_added_to_board.connect(_on_domino_added_to_board)
		Signals.domino_chain_removed.connect(_on_domino_chain_removed)
		Global.play_btn = self
		Global.fight_scene = self


func show_head_ui() -> void:
	var pool := []
	for key in Run.reserved_head_pool:
		pool.push_back(key)
	
	var final_pool := []
	for key in Run.current_head_pool:
		final_pool.push_back(key)
	
	var random_head_key = ""
	if not pool.is_empty():
		random_head_key = pool.pick_random()
		random_head_key = "berserk"
		final_pool.push_back(random_head_key)
	
	if final_pool.is_empty():
		await get_tree().process_frame
		Signals.enemy_head_choosen.emit(null)
		return
	
	var new_head = HeadManager.head_pool[random_head_key].instantiate()
	random_head = new_head
	
	if final_pool.size() == 1:
		new_head.invert_logic = true
		Global.enemy_head_holder.add_child(new_head)
		await get_tree().process_frame
		Signals.enemy_head_choosen.emit(head_buffer)
		head_buffer = null
		random_head = null
	else:
		Global.head_holder.add_child(new_head)
		
		head_origin = Global.head_holder.center_position
		heads_ui.show()
		heads_ui.modulate.a = 0.0
		
		# Перемещаем головы в центр экрана.
		var tween = create_tween().set_parallel()
		tween.tween_property(Global.head_holder, "center_position", get_viewport_rect().size * 0.5, 0.5)
		tween.tween_property(heads_ui, "modulate:a", 1.0, 0.5)
		await tween.finished
		
		Signals.head_selected.connect(head_selected)
		
		for head: Node2D in Global.head_holder.get_children():
			if head is Head:
				head.head_choice = true
				head.invert_logic = true
			
		await Signals.head_selected
		Signals.head_selected.disconnect(head_selected)
		


func head_selected(head: Head) -> void:
	head.get_parent().remove_child(head)
	Global.enemy_head_holder.add_child(head)
	head.apply_passive_effect()
	
	for head2: Node2D in Global.head_holder.get_children():		
		if head2 is Head:
			head2.head_choice = false
			head2.invert_logic = false
			if head2 == random_head:
				var tween = create_tween()
				tween.tween_property(head2, "modulate:a", 0.0, 0.5)
				await tween.finished
				head2.queue_free()
	head_buffer = head
	
	# Возвращаем головы на прежнее место.
	var tween2 = create_tween().set_parallel()
	tween2.tween_property(Global.head_holder, "center_position", head_origin, 0.5)
	tween2.tween_property(heads_ui, "modulate:a", 0.0, 0.5)
	await tween2.finished
	
	heads_ui.hide()
	Signals.enemy_head_choosen.emit(head_buffer)
	head_buffer = null
	random_head = null


func hide_head_ui() -> void:
	heads_ui.hide()


func start() -> void:
	camera.make_current()
	Foreground.options_panel.show_box(Foreground.options_panel.battle_box)


func _on_domino_chain_removed() -> void:
	if DominoManager.dominoes_on_board.is_empty():
		play_btn.disabled = true


func _on_player_turn_end() -> void:
	play_btn.disabled = true


func _on_domino_added_to_board(_domino: Domino) -> void:
	play_btn.disabled = false


## Происходит при нажатии кнопки 'Играть'.
func _on_play_btn_pressed() -> void:
	if DominoManager.block_domino_input:
		return
	Signals.play_btn_pressed.emit()


func show_menu() -> void:
	var pos1 = Vector2(414, 15 + 25) + offset # сначала вниз на 20
	var pos2 = Vector2(414, 10 + 25) + offset

	var tween = main_buttons_box.create_tween()
	tween.tween_property(main_buttons_box, "global_position", pos1, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(main_buttons_box, "global_position", pos2, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func hide_menu() -> void:
	var start_pos = main_buttons_box.global_position
	var pos1 = start_pos + Vector2(0, 5) # небольшое смещение вниз
	var pos2 = Vector2(414, -60) - offset
	#var pos2 = Vector2(320, -145)

	var tween = main_buttons_box.create_tween()
	tween.tween_property(main_buttons_box, "global_position", pos1, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(main_buttons_box, "global_position", pos2, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
