extends ActionCard

func _ready() -> void:
	bonus_card = true
	description = tr("remove_2_domino_des")
	super()
	
func effect():
	CombatManager.show_delete_domino_menu()
	ActionCardManager.hide_cont()
