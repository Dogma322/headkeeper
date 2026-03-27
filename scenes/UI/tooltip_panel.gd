@tool
extends MarginContainer
class_name TooltipPanel

@onready var v_box_container: VBoxContainer = %VBoxContainer
@onready var caption_label: Label = %CaptionLabel
@onready var description_label: RichTextLabel = %DescriptionLabel

enum ShowOffset {
	NONE,
	RIGHT_TOP,
	RIGHT_CENTER,
	RIGHT_BOTTOM,
	LEFT_TOP,
	LEFT_CENTER,
	LEFT_BOTTOM
}

@export var caption: String:
	set(value):
		caption = value
		if is_instance_valid(caption_label):
			caption_label.text = value
			if value.is_empty():
				caption_label.hide()
			else:
				caption_label.show()

@export var description: String:
	set(value):
		description = value
		if is_instance_valid(description_label):
			description_label.text = value

var tween: Tween
var mouse_over := false
var origin_pos := Vector2.ZERO
var origin_size := Vector2.ZERO

func _ready() -> void:
	if caption.is_empty():
		caption_label.hide()
	else:
		caption_label.show()
	caption_label.text = caption
	description_label.text = description
	origin_pos = position
	origin_size = size

func show_tooltip(await_frame: bool = false, ui_element: Control = null, offset := ShowOffset.NONE) -> void:
	visible = true
	if await_frame:
		await get_tree().create_timer(0.001).timeout
	match offset:
		ShowOffset.NONE:
			pass
		ShowOffset.RIGHT_TOP:
			assert(ui_element)
			pass
		ShowOffset.RIGHT_CENTER:
			assert(ui_element)
			global_position.x = ui_element.global_position.x + ui_element.size.x
			global_position.y = ui_element.global_position.y + ui_element.size.y / 2.0 - size.y / 2.0
			pass
		ShowOffset.RIGHT_BOTTOM:
			assert(ui_element)
			pass
		ShowOffset.LEFT_TOP:
			assert(ui_element)
			pass
		ShowOffset.LEFT_CENTER:
			assert(ui_element)
			global_position.x = ui_element.global_position.x - size.x
			global_position.y = ui_element.global_position.y + ui_element.size.y / 2.0 - size.y / 2.0
			pass
		ShowOffset.LEFT_BOTTOM:
			assert(ui_element)
			pass
	
	if tween and tween.is_running():
		tween.kill()
	
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.15)


func hide_tooltip() -> bool:
	if not is_visible_in_tree():
		return false
	
	if not mouse_over: # не скрываем, если курсор снова вернулся
		if tween and tween.is_running():
			tween.kill()
		
		tween = get_tree().create_tween()
		tween.tween_property(self, "modulate:a", 0, 0.15)
		await tween.finished
		if not mouse_over:
			visible = false
		return true
	return false
