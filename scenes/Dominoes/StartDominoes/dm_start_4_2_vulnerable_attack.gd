extends Domino

func _ready() -> void:
	domino_types = ["Attack", "Skill"]
	damage = 4
	super()


func add_action():
	ActionManager.add(AttackDebuffAction.new(self, Global.enemy, 5, StatusManager.vulnerable, 2))
	
func update_labels():
	await get_tree().process_frame
	tooltip_panel.description = TextFormatter.insert_colored_value(tr("attack_des"), final_damage(damage), damage) + " " + TextFormatter.highlight_keywords(tr("vulnerable_des") % 2)
