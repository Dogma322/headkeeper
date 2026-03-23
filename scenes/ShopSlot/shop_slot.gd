extends VBoxContainer
class_name ShopSlot

@onready var icon_rect: TextureRect = %IconRect
@onready var cost_label: Label = %CostLabel

@export var tooltip_offset: TooltipPanel.ShowOffset = TooltipPanel.ShowOffset.NONE

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

func _ready() -> void:
	icon_rect.texture = null
	cost_label.text = str(0)
	cost_label.modulate = Color.TRANSPARENT
	icon_rect.mouse_entered.connect(_show_item_tooltip)

func _show_item_tooltip():
	pass
