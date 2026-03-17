extends Domino

func _ready() -> void:
	domino_types = ["Attack", "Skill"]
	damage = 6
	corruption = 3
	super()


func add_action():
	ActionManager.add(AttackDebuffAction.new(self, Global.enemy, 6, StatusManager.corruption, 3))
	
func update_labels():
	await get_tree().process_frame
	des_label.text = TextFormatter.insert_colored_value(tr("attack_des"), final_damage(damage), damage) + " " + TextFormatter.insert_colored_value(tr("corruption_des"), 3, 3) 
