@tool
extends Node2D
class_name BattleScene

@onready var characters = $Characters
@onready var play_btn: GameButton = %PlayBtn


func _ready() -> void:
	play_btn.text = tr("play")
	
	if not Engine.is_editor_hint():
		Global.play_btn = self
		Global.fight_scene = self
		CombatManager.start()


## Происходит при нажатии кнопки 'Играть'.
func _on_play_btn_pressed() -> void:
	if DominoManager.block_domino_input:
		return
	Signals.play_btn_pressed.emit()


func show_play_btn() -> void:
	var pos1 = Vector2(414, 15) # сначала вниз на 20
	var pos2 = Vector2(414, 10)

	var tween = play_btn.create_tween()
	tween.tween_property(play_btn, "global_position", pos1, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(play_btn, "global_position", pos2, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func hide_play_btn() -> void:
	var start_pos = play_btn.global_position
	var pos1 = start_pos + Vector2(0, 5) # небольшое смещение вниз
	var pos2 = Vector2(414, -50)
	#var pos2 = Vector2(320, -145)

	var tween = play_btn.create_tween()
	tween.tween_property(play_btn, "global_position", pos1, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(play_btn, "global_position", pos2, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
