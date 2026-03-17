extends Domino

func _ready() -> void:
	domino_types = ["Attack"]
	super()



func add_action():
	ActionManager.add(HammerAction.new(self, Global.enemy))
	
func update_labels():
	await get_tree().process_frame
	damage = BoardManager.green_bonuses_activated * 2
	des_label.text = TextFormatter.insert_colored_value(tr("dm_hammer_des"), final_damage(damage), damage)
