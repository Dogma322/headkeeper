extends ActionCard

func _ready() -> void:
	bonus_card = true
	description = tr("add_board_bonus_des")
	super()
	
func effect():
	ActionCardManager.show_bonus_action_cards()
