extends Node2D
class_name Board

@export var is_temp := false

func _ready() -> void:
	if not is_temp:
		Global.board = self


func show_board():
	var pos1 = Vector2(320, 165) # сначала вниз на 20
	var pos2 = Vector2(320, 145)

	var tween = create_tween()
	tween.tween_property(self, "global_position", pos1, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", pos2, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
func hide_board():
	var start_pos = global_position
	var pos1 = start_pos + Vector2(0, 20) # небольшое смещение вниз
	var pos2 = Vector2(320, -180)
	#var pos2 = Vector2(320, -145)

	var tween = create_tween()
	tween.tween_property(self, "global_position", pos1, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", pos2, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
