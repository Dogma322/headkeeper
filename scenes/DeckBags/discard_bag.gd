extends TextureButton

@onready var tooltip_panel: TooltipPanel = $TooltipPanel
@onready var deck_label = $DeckLabel

func _ready() -> void:
	Signals.deck_changed.connect(update_labels)
	update_labels()
	hide_des()


func _process(_delta: float) -> void:
	deck_label.text = str(DominoManager.discard.size())


func show_des():
	update_labels()
	tooltip_panel.show_tooltip()


func hide_des():
	tooltip_panel.hide_tooltip()


func update_labels():
	tooltip_panel.caption = tr("discard_bag_name")
	tooltip_panel.description = tr("bag_des") % DominoManager.discard.size()


func _on_mouse_entered() -> void:
	show_des()


func _on_mouse_exited() -> void:
	hide_des()
