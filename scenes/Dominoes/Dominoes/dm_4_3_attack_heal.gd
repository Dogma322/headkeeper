extends Domino

func _ready() -> void:
	domino_types = ["Attack", "Skill"]
	damage = 8
	heal = 3
	super()


func add_action():
	ActionManager.add(AttackAction.new(self, Global.enemy, 8))
	ActionManager.add(HealAction.new(self, Global.hero, 3))
	
func update_labels():
	await get_tree().process_frame
	TextFormatter.insert_colored_value(tr("attack_des"), final_damage(damage), damage) + " " + TextFormatter.insert_colored_value(tr("heal_des"), final_heal(heal), heal) 
