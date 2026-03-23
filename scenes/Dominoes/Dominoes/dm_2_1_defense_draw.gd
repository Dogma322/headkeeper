extends Domino

func _ready() -> void:
	domino_types = ["Defense", "Skill"]
	block = 2
	super()


func add_action():
	ActionManager.add(BlockAction.new(self, Global.hero, 2))
	ActionManager.add(BuffAction.new(self, Global.hero,StatusManager.draw,1))
	
func update_labels():
	await get_tree().process_frame
	tooltip_panel.description = TextFormatter.insert_colored_value(tr("defense_des"), final_block(block), block) + " " + tr("draw_1_des") 
