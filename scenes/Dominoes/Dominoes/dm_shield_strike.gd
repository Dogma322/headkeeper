extends Domino

func _ready() -> void:
	domino_types = ["Attack", "Defense"]
	block = 2
	super()



func add_action():
	ActionManager.add(BlockAction.new(self, Global.hero, 2))
	ActionManager.add(ShieldStrikeAction.new(self, Global.enemy))
	
func update_labels():
	await get_tree().process_frame
	tooltip_panel.description = TextFormatter.insert_colored_value(tr("defense_des"), final_block(block), block) + " " + TextFormatter.highlight_keywords(tr("dm_shield_strike_des"))
