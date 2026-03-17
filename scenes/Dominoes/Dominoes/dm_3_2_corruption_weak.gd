extends Domino

func _ready() -> void:
	domino_types = ["Skill"]
	corruption = 3
	super()


func add_action():
	ActionManager.add(DebuffAction.new(self, Global.enemy,StatusManager.corruption, 3))
	ActionManager.add(DebuffAction.new(self, Global.enemy,StatusManager.weak, 2))
	
func update_labels():
	await get_tree().process_frame
	des_label.text = TextFormatter.insert_colored_value(tr("corruption_des"), final_corruption(corruption), corruption) + " " + TextFormatter.highlight_keywords(tr("weak_des") % 2)
