extends Domino

func _ready() -> void:
	domino_types = ["Attack"]
	damage = 5
	super()


func add_action():
	ActionManager.add(AttackAction.new(self, Global.enemy, 5))
	#ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.fury, 3))
	#ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.fury, 3))
	#ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.crit, 1))
	#ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.corruption, 100))
	#ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.vulnerable, 5))
	#DominoManager.double_next_dm += 1
	
func update_labels():
	await get_tree().process_frame
	tooltip_panel.description = TextFormatter.insert_colored_value(tr("attack_des"), final_damage(damage), damage)
