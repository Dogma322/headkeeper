extends Domino

func _ready() -> void:
	domino_types = ["Skill"]
	heal = 5
	super()


func add_action():
	ActionManager.add(HealAction.new(self, Global.hero, 5))
	
func update_labels():
	await get_tree().process_frame
	des_label.text = TextFormatter.insert_colored_value(tr("heal_des"), final_heal(heal), heal)
