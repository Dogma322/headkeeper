extends Domino

func _ready() -> void:
	domino_types = ["Skill", "Defense"]
	block = 3
	super()


func add_action():
	ActionManager.add(BlockAction.new(self, Global.hero, 3))
	ActionManager.add(BuffAction.new(self, Global.hero,StatusManager.crit, 1))

	
func update_labels():
	await get_tree().process_frame
	tooltip_panel.description = TextFormatter.insert_colored_value(tr("defense_des"), final_block(block), block) + " " + TextFormatter.highlight_keywords(tr("dm_crit_des"))
