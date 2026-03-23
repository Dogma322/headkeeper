extends Domino

func _ready() -> void:
	domino_types = ["Skill"]
	super()

func add_action():
	ActionManager.add(CorruptedStuffAction.new(self, Global.enemy))
	
func update_labels():
	await get_tree().process_frame
	corruption = DominoManager.value2_played_dominoes
	tooltip_panel.description = TextFormatter.insert_colored_value(tr("dm_dark_staff_des"), final_corruption(corruption), corruption)
