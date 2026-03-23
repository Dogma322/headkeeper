extends Domino

func _ready() -> void:
	domino_types = ["Defense", "Skill"]
	block = 4
	super()


func add_action():
	ActionManager.add(BlockAction.new(self, Global.hero, 4))
	ActionManager.add(BuffAction.new(self, Global.hero,StatusManager.thorns, 2))
	
func update_labels():
	await get_tree().process_frame
	tooltip_panel.description = TextFormatter.insert_colored_value(tr("defense_des"), final_block(block), block) + " " + TextFormatter.highlight_keywords(tr("thorns_des") % 2)
