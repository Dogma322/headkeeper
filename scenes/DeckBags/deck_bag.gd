extends TextureButton

@onready var tooltip_panel: TooltipPanel = $TooltipPanel
@onready var deck_label = $DeckLabel

var des_tween: Tween
var mouse_over_des = false


func _ready() -> void:
	update_labels()
	hide_des()


func _process(_delta: float) -> void:
	deck_label.text = str(DominoManager.temp_deck.size())


func show_des():
	update_labels()
	tooltip_panel.show_tooltip()

	
func hide_des():
	tooltip_panel.hide_tooltip()


func update_labels():
	tooltip_panel.caption = tr("bone_bag_name")
	tooltip_panel.description = tr("bag_des") % DominoManager.temp_deck.size()


func _on_mouse_entered() -> void:
	mouse_over_des = true
	show_des()


func _on_mouse_exited() -> void:
	mouse_over_des = false
	hide_des()
