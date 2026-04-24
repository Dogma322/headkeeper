extends TextureButton
class_name DiscardBag

@onready var deck_label: Label = $DeckLabel
@onready var tooltip_panel: TooltipPanel = $TooltipPanel

func _ready() -> void:
	Signals.discard_deck_changed.connect(update_labels)
	
	update_labels()
	hide_description()


func show_description() -> void:
	tooltip_panel.show_tooltip()


func hide_description() -> void:
	tooltip_panel.hide_tooltip()


func update_labels() -> void:
	deck_label.text = str(DominoManager.discard.size())
	tooltip_panel.caption = tr("discard_bag_name")
	tooltip_panel.description = tr("bag_des") % DominoManager.discard.size()


func _on_mouse_entered() -> void:
	show_description()
	self_modulate = Color.WHITE.darkened(0.25)


func _on_mouse_exited() -> void:
	hide_description()
	self_modulate = Color.WHITE
