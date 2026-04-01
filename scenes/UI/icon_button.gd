class_name IconButton
extends TextureButton


func _on_mouse_entered() -> void:
	modulate = Color(1.3, 1.3, 1.3)


func _on_mouse_exited() -> void:
	modulate = Color(1, 1, 1)
