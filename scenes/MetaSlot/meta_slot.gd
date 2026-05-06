extends VBoxContainer
class_name MetaSlot

@onready var icon_rect: TextureRect = %IconRect
@onready var cost_label: Label = %CostLabel

@export var tooltip_offset: TooltipPanel.ShowOffset = TooltipPanel.ShowOffset.NONE

signal selected

@export var key: String

var hname := ""
var description := ""

@export var head: HeadTemplate:
	set(value):
		head = value
		if head:
			# HACK: но не придумал ничего лучше
			var h: Head = HeadManager.head_pool[key].instantiate()
			h._update_desc()
			hname = h.hd_name
			description = h.description
			h.free()
			
			icon_rect.texture = head.texture
			cost_label.text = str(head.skulls_cost)
			cost_label.modulate = Color.WHITE
		else:
			hname = ""
			description = ""
			icon_rect.texture = null
			cost_label.text = str(0)
			cost_label.modulate = Color.TRANSPARENT

var not_enough_skulls := false

var center: Vector2:
	get:
		return icon_rect.global_position + icon_rect.size / 2.0

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


func try_buy(skulls: int) -> bool:
	if not head or buyed:
		return false
	if skulls < head.skulls_cost:
		return false
	buyed = true 
	return true


func update_availability(skulls: int) -> void:
	if not head or buyed:
		return
	if head.skulls_cost > skulls:
		icon_rect.modulate = Color.DIM_GRAY
		cost_label.modulate = Color.DIM_GRAY
		not_enough_skulls = true
	else:
		icon_rect.modulate = Color.WHITE
		cost_label.modulate = Color.WHITE
		not_enough_skulls = false


func _ready() -> void:
	icon_rect.texture = null
	cost_label.text = str(0)
	cost_label.modulate = Color.TRANSPARENT


func _on_icon_rect_mouse_entered() -> void:
	if head and not not_enough_skulls and not is_selected:
		icon_rect.modulate = Color.WEB_GRAY


func _on_icon_rect_mouse_exited() -> void:
	if head and not not_enough_skulls and not is_selected:
		icon_rect.modulate = Color.WHITE


func _on_icon_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			selected.emit()
