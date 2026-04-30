extends ActionCard

func _ready() -> void:
	bonus_card = true
	description = tr("add_head_des") #tr("add_board_bonus_des")
	super()
	
func effect():
	SceneManager.main_scene = SceneManager.choice_scene
	SceneManager.show_choice_scene()
	SceneManager.choice_scene.spawn_heads()
	await Signals.head_selected
	Signals.action_card_selected.emit()
	
	#ActionCardManager.show_bonus_action_cards()
