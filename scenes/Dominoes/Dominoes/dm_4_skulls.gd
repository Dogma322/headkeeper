extends Domino

func _ready() -> void:
	domino_types = ["Attack"]
	super()



func add_action():
	ActionManager.add(SkullsAction.new(self, Global.enemy))
	
func update_labels():
	await get_tree().process_frame
	damage = DominoManager.value4_played_dominoes * 2
	des_label.text = TextFormatter.insert_colored_value(tr("4value_attack_des"), final_damage(damage), damage)
