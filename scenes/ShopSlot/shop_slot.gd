extends VBoxContainer
class_name ShopSlot

@onready var icon_rect: TextureRect = %IconRect
@onready var cost_label: Label = %CostLabel

@export var tooltip_offset: TooltipPanel.ShowOffset = TooltipPanel.ShowOffset.NONE

signal selected

@export var key: String

@export var head: HeadTemplate:
	set(value):
		head = value
		if head:
			icon_rect.texture = head.texture
			cost_label.text = str(head.cost)
			cost_label.modulate = Color.WHITE
		else:
			icon_rect.texture = null
			cost_label.text = str(0)
			cost_label.modulate = Color.TRANSPARENT

var not_enough_money := false

var buyed := false:
	set(value):
		buyed = value
		if value:
			cost_label.modulate = Color.TRANSPARENT
		else:
			cost_label.modulate = Color.WHITE

var is_selected := false:
	set(value):
		is_selected = value
		if value:
			icon_rect.modulate = Color.TRANSPARENT
		else:
			icon_rect.modulate = Color.WHITE

func select() -> void:
	is_selected = true


func unselect() -> void:
	is_selected = false


func try_buy(money: int) -> bool:
	if not head or buyed:
		return false
	if money < head.cost:
		return false
	buyed = true 
	return true


func update_availability(money: int) -> void:
	if not head or buyed:
		return
	if head.cost > money:
		icon_rect.modulate = Color.DIM_GRAY
		cost_label.modulate = Color.DIM_GRAY
		not_enough_money = true
	else:
		icon_rect.modulate = Color.WHITE
		cost_label.modulate = Color.WHITE
		not_enough_money = false


func _ready() -> void:
	icon_rect.texture = null
	cost_label.text = str(0)
	cost_label.modulate = Color.TRANSPARENT


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			selected.emit()


func _on_mouse_entered() -> void:
	if head and not not_enough_money and not is_selected:
		icon_rect.modulate = Color.WEB_GRAY


func _on_mouse_exited() -> void:
	if head and not not_enough_money and not is_selected:
		icon_rect.modulate = Color.WHITE
