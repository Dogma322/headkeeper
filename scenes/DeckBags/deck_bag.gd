extends TextureButton

@onready var tooltip_panel: TooltipPanel = $TooltipPanel
@onready var deck_label = $DeckLabel

var des_tween: Tween
var mouse_over_des = false


func _ready() -> void:
	Signals.deck_changed.connect(update_labels)
	
	update_labels()
	hide_des()


func show_des():
	update_labels()
	tooltip_panel.show_tooltip()


func hide_des():
	tooltip_panel.hide_tooltip()


func update_labels():
	deck_label.text = str(DominoManager.temp_deck.size())
	tooltip_panel.description = tr("ID_BAG_DESC") % DominoManager.temp_deck.size()


func _on_mouse_entered() -> void:
	mouse_over_des = true
	show_des()
	self_modulate = Color.WHITE.darkened(0.25)


func _on_mouse_exited() -> void:
	mouse_over_des = false
	hide_des()
	self_modulate = Color.WHITE
