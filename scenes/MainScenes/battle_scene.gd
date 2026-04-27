@tool
extends ScreenBase
class_name BattleScene

@onready var characters = $Characters
@onready var play_btn: GameButton = %PlayBtn
@onready var main_buttons_box: VBoxContainer = $MainButtonsBox
@onready var board_1: Board = $Board/Board1
@onready var hand: Node2D = $Hand
@onready var camera: Node2D = $Camera

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
 

func start():
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
