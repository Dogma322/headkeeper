@tool
extends Control
class_name GameButton

@onready var label: Label = %Label
@onready var nine_patch_rect: NinePatchRect = $NinePatchRect

signal pressed

## Текст на кнопке.
@export var text := "":
	set(value):
		if text == value:
			return
		text = value
		if is_instance_valid(label):
			label.text = value

@export_enum('7','8','10','12','15') var font_size: int:
	set(value):
		if font_size == value:
			return
		font_size = value
		if is_instance_valid(label):
			_update_font_size()

@export var use_darkened := false

@export var disabled: bool:
	set(value):
		disabled = value
		if value:
			modulate = Color.DIM_GRAY
		else:
			modulate = Color.WHITE

func _update_font_size():
	match font_size:
		0:
			label.theme = preload("res://scenes/TextThemes/volda7.tres")
		1:
			label.theme = preload("res://scenes/TextThemes/volda8.tres")
		2:
			label.theme = preload("res://scenes/TextThemes/volda10.tres")
		3:
			label.theme = preload("res://scenes/TextThemes/volda12.tres")
		4:
			label.theme = preload("res://scenes/TextThemes/volda15.tres")

func _ready() -> void:
	label.text = text
	_update_font_size()
	pass


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and not disabled:
			pressed.emit()


func _on_mouse_entered() -> void:
	if disabled:
		return
	if use_darkened:
		nine_patch_rect.modulate = Color(0.7, 0.7, 0.7)
	else:
		nine_patch_rect.modulate = Color(1.3, 1.3, 1.3)


func _on_mouse_exited() -> void:
	if disabled:
		return
	nine_patch_rect.modulate = Color(1, 1, 1)
