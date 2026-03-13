extends Control





func _on_btn_pressed() -> void:
	Signals.play_btn_pressed.emit()


func _on_btn_mouse_entered() -> void:
	modulate = Color(0.7,0.7,0.7)


func _on_btn_mouse_exited() -> void:
	modulate = Color(1,1,1)
