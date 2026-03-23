extends Domino

func _ready() -> void:
	domino_types = ["Attack", "Skill"]
	damage = 4
	super()


func add_action():
	ActionManager.add(AttackAction.new(self, Global.enemy, 4))
	ActionManager.add(BuffAction.new(self, Global.hero,StatusManager.draw,1))
	
func update_labels():
	await get_tree().process_frame
	tooltip_panel.description = TextFormatter.insert_colored_value(tr("attack_des"), final_damage(damage), damage) + " " + tr("draw_1_des") 
