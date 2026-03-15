extends TextureButton
class_name ActionCard

@onready var des_label = $Label
@onready var description = ""
var bonus_card = false

func _ready() -> void:
	focus_mode = Control.FOCUS_NONE
	des_label.text = description


func _on_pressed() -> void:
	if !ActionCardManager.action_card_is_pressed:
		ActionCardManager.action_card_is_pressed = true
		effect()
		if !bonus_card:
			Signals.action_card_selected.emit()
	
	
func effect():
	pass

func _on_mouse_entered() -> void:
	modulate = Color(1.3, 1.3, 1.3)


func _on_mouse_exited() -> void:
	modulate = Color(1, 1, 1)
