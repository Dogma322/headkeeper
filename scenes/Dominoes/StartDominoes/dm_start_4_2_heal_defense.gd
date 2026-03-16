extends Domino

func _ready() -> void:
	domino_types = ["Defense", "Skill"]
	block = 4
	heal = 2
	super()


func add_action():
	ActionManager.add(BlockAction.new(self, Global.hero, 4))
	ActionManager.add(HealAction.new(self, Global.hero, 2))
	
func update_labels():
	await get_tree().process_frame
	des_label.text = TextFormatter.insert_colored_value(tr("defense_des"), final_block(block), block) + " " + TextFormatter.highlight_keywords(tr("heal_des") % heal)
