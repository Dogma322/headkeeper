class_name IconButton
extends TextureButton

func _ready() -> void:
	toggled.connect(_on_toggled)
	if button_pressed:
		modulate = Color(1.5, 1.5, 1.5)


func _on_mouse_entered() -> void:
	if toggle_mode and button_pressed:
		return
	modulate = Color(1.3, 1.3, 1.3)


func _on_mouse_exited() -> void:
	if toggle_mode and button_pressed:
		return
	modulate = Color(1, 1, 1)


func _on_toggled(_toggled_on: bool) -> void:
	if button_group != null:
		for button: BaseButton in button_group.get_buttons():
			if button == button_group.get_pressed_button():
				button.modulate = Color(1.5, 1.5, 1.5)
			else:
				button.modulate = Color(1, 1, 1)
		
