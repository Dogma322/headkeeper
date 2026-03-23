extends Domino

func _ready() -> void:
	domino_types = ["Attack"]
	super()

func add_action():
	ActionManager.add(AttackAction.new(self, Global.enemy, DominoManager.dominoes_on_board.size() * 3))
	
func update_labels():
	await get_tree().process_frame
	damage = DominoManager.dominoes_on_board.size() * 3 + 3
	tooltip_panel.description = TextFormatter.insert_colored_value(tr("dm_mace_des"), final_damage(damage), damage + 3)
