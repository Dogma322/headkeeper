@tool
extends Control
class_name GameButton

@onready var label: RichTextLabel = %Label
@onready var nine_patch_rect: NinePatchRect = $NinePatchRect

signal pressed

static var buttons = []

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

@export var disabled: bool = false:
	set(value):
		disabled = value
		if value:
			modulate = Color.DIM_GRAY
		else:
			modulate = Color.WHITE

var active := true

func _update_font_size():
	var amount := 0
	
	match font_size:
		0:
			amount = 7
		1:
			amount = 8
		2:
			amount = 10
		3:
			amount = 12
		4:
			amount = 15
	label.add_theme_font_size_override("normal_font_size", amount)
	label.add_theme_font_size_override("bold_font_size", amount)
	label.add_theme_font_size_override("bold_italics_font_size", amount)
	label.add_theme_font_size_override("italics_font_size", amount)
	label.add_theme_font_size_override("mono_font_size", amount)

func _ready() -> void:
	buttons.push_back(self)
	label.text = text
	_update_font_size()
	pass

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		buttons.erase(self)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and not disabled:
			if not active:
				return
			pressed.emit()

static func activate_all_buttons(enabled := true) -> void:
	for button in buttons:
		button.active = enabled

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
