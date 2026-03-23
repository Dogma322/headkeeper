extends Domino

func _ready() -> void:
	domino_types = ["Defense"]
	block = 5
	super()


func add_action():
	ActionManager.add(BlockAction.new(self, Global.hero, 5))
	
func update_labels():
	await get_tree().process_frame
	tooltip_panel.description = TextFormatter.insert_colored_value(tr("defense_des"), final_block(block), block)
