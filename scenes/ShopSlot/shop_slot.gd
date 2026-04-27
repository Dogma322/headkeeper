@tool
extends VBoxContainer
class_name ShopSlot

@onready var icon_rect: TextureRect = %IconRect
@onready var cost_label: Label = %CostLabel
@onready var domino: Domino = $Domino

signal selected

enum ItemType {
	NONE,
	HEAD,
	BONUS,
	DOMINO,
	REMOVE_DOMINO,
}

var screen: ShopScene = null

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
			ItemType.BONUS:
				var bonus: BonusTemplate = BonusManager.bonus_templates[item_key]
				icon_rect.texture = bonus.texture
			ItemType.DOMINO:
				var domino_template: DominoTemplate = DominoManager.domino_templates[item_key]
				domino.template = domino_template
				domino.show()
				domino.setup(Domino.SideSettings.new(domino_template.a_types, domino_template.a_color),
				Domino.SideSettings.new(domino_template.b_types, domino_template.b_color))

func _ready() -> void:
	match item_type:
		ItemType.REMOVE_DOMINO:
			icon_rect.texture = preload("res://assets/Shop/RemoveDominoBtn.png")
		_:
			icon_rect.texture = null
	cost_label.text = str(item_cost)


func try_buy(gold: int) -> bool:
	if item_type == ItemType.NONE:
		return false
	if gold < item_cost:
		return false
	queue_free()
	return true


func _on_icon_rect_mouse_entered() -> void:
	icon_rect.modulate = Color.WEB_GRAY
	
	match item_type:
		ItemType.HEAD:
			var head: HeadTemplate = HeadManager.head_templates[item_key]
			screen.tooltip_panel.caption = head.get_translated_name()
			screen.tooltip_panel.description = head.get_translated_desc()
		ItemType.BONUS:
			var bonus: BonusTemplate = BonusManager.bonus_templates[item_key]
			screen.tooltip_panel.caption = ""
			screen.tooltip_panel.description = tr(bonus.desc)
		ItemType.DOMINO:
			domino.show_description()
			domino.modulate = Color.WEB_GRAY
		ItemType.REMOVE_DOMINO:
			screen.tooltip_panel.caption = ""
			screen.tooltip_panel.description = tr("remove_card_des")
	
	if item_type != ItemType.DOMINO:
		screen.tooltip_panel.reset_size()
		screen.tooltip_panel.show_tooltip(true, icon_rect, TooltipPanel.ShowOffset.RIGHT_CENTER)


func _on_icon_rect_mouse_exited() -> void:
	icon_rect.modulate = Color.WHITE
	if item_type == ItemType.DOMINO:
		domino.modulate = Color.WHITE
		domino.hide_description()
	else:
		screen.tooltip_panel.hide_tooltip()


func _on_icon_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			selected.emit()
