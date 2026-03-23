extends Domino

func _ready() -> void:
	domino_types = ["Skill"]
	super()


func add_action():
	ActionManager.add(BuffAction.new(self, Global.hero,StatusManager.repeat, 1))
	DominoManager.double_next_dm += 1
	
func update_labels():
	await get_tree().process_frame
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("dm_repeat_des")) 
