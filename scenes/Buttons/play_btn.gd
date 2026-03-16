extends Control

func _ready() -> void:
	Global.play_btn = self


func show_btn():
	var pos1 = Vector2(414, 15) # сначала вниз на 20
	var pos2 = Vector2(414, 10)

	var tween = create_tween()
	tween.tween_property(self, "global_position", pos1, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", pos2, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
func hide_btn():
	var start_pos = global_position
	var pos1 = start_pos + Vector2(0, 5) # небольшое смещение вниз
	var pos2 = Vector2(414, -50)
	#var pos2 = Vector2(320, -145)

	var tween = create_tween()
	tween.tween_property(self, "global_position", pos1, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", pos2, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)









func _on_btn_pressed() -> void:
	if DominoManager.block_domino_input:
		return
	Signals.play_btn_pressed.emit()


func _on_btn_mouse_entered() -> void:
	modulate = Color(0.7,0.7,0.7)


func _on_btn_mouse_exited() -> void:
	modulate = Color(1,1,1)
