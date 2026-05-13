@tool
class_name IconButton
extends TextureRect

@export var toggle_mode := false
@export var button_pressed := false:
	set(value):
		button_pressed = value
		if value:
			modulate = Color(1.5, 1.5, 1.5)
		else:
			if mouse_over:
				modulate = Color(1.3, 1.3, 1.3)
			else:
				modulate = Color(1, 1, 1)
@export var button_group: String
@export var shortcut: Shortcut
@export var tooltip: String
@export var tooltip_offset: TooltipPanel.ShowOffset

var active := true
var disabled := false
var mouse_over := false

static var buttons = []
static var button_groups = {}

signal toggled(button_pressed)
signal pressed


func _ready() -> void:
	buttons.push_back(self)
	if button_group != null and !button_group.is_empty():
		button_groups.get_or_add(button_group, []).push_back(self)
	if button_pressed:
		modulate = Color(1.5, 1.5, 1.5)
	else:
		modulate = Color(1, 1, 1)


static func activate_all_buttons(enabled := true) -> void:
	for button in buttons:
		button.active = enabled


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		buttons.erase(self)


func _on_mouse_entered() -> void:
	mouse_over = true
	
	if not active or disabled:
		return
	
	if not tooltip.is_empty():
		Foreground.tooltip_panel.description = tr(tooltip)
		Foreground.tooltip_panel.show_tooltip(true, self, tooltip_offset)
	
	if toggle_mode and button_pressed:
		return
	modulate = Color(1.3, 1.3, 1.3)
	


func _on_mouse_exited() -> void:
	mouse_over = false
	
	if not active or disabled:
		return
	
	if not tooltip.is_empty():
		Foreground.tooltip_panel.hide_tooltip()
	
	if toggle_mode and button_pressed:
		return
	modulate = Color(1, 1, 1)
	

func _input(event: InputEvent) -> void:
	if shortcut and shortcut.matches_event(event) and event.is_pressed() and not event.is_echo():
		_press()


func _gui_input(event: InputEvent) -> void:
	if not active or disabled:
		return
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
			_press()


func _press():
	if toggle_mode:
		if button_group != null and !button_group.is_empty():
			for button in button_groups[button_group]:
				if button == self:
					if button_pressed:
						continue
					button_pressed = true
					pressed.emit()
				else:
					button.button_pressed = false
		else:
			button_pressed = !button_pressed
			toggled.emit(button_pressed)
	else:
		pressed.emit()
