@tool
extends VBoxContainer
class_name ShopSlot

@onready var icon_rect: TextureRect = %IconRect
@onready var cost_label: Label = %CostLabel

signal selected

enum ItemType {
	NONE,
	HEAD,
	BONUS,
	DOMINO,
	REMOVE_DOMINO,
}

@export var item_type := ItemType.NONE:
	set(value):
		item_type = value
		if is_instance_valid(icon_rect):
			match item_type:
				ItemType.REMOVE_DOMINO:
					icon_rect.texture = preload("res://assets/Shop/RemoveDominoBtn.png")

@export var item_cost := 0:
	set(value):
		item_cost = value
		if is_instance_valid(cost_label):
			cost_label.text = str(item_cost)

@export var tooltip_offset: TooltipPanel.ShowOffset = TooltipPanel.ShowOffset.NONE

var item_key := "":
	set(value):
		item_key = value
		match item_type:
			ItemType.HEAD:
				var head: HeadTemplate = HeadManager.head_templates[item_key]
				icon_rect.texture = head.texture

var buyed := false:
	set(value):
		buyed = value
		if value:
			icon_rect.modulate = Color.TRANSPARENT
			cost_label.modulate = Color.TRANSPARENT
		else:
			icon_rect.modulate = Color.WHITE
			cost_label.modulate = Color.WHITE


func _ready() -> void:
	match item_type:
		ItemType.REMOVE_DOMINO:
			icon_rect.texture = preload("res://assets/Shop/RemoveDominoBtn.png")
		_:
			icon_rect.texture = null
	cost_label.text = str(item_cost)


func try_buy(gold: int) -> bool:
	if item_type == ItemType.NONE or buyed:
		return false
	if gold < item_cost:
		return false
	buyed = true 
	return true


func _on_icon_rect_mouse_entered() -> void:
	icon_rect.modulate = Color.WEB_GRAY


func _on_icon_rect_mouse_exited() -> void:
	icon_rect.modulate = Color.WHITE


func _on_icon_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			selected.emit()
