extends Domino

func _ready() -> void:
	domino_types = ["Attack"]
	damage = 8
	Signals.fight_started.connect(reset_damage)
	super()
	
func reset_damage():
	damage = 8


func add_action():
	ActionManager.add(AttackAction.new(self, Global.enemy, 8))
	damage += 4
	
func update_labels():
	await get_tree().process_frame
	des_label.text = TextFormatter.insert_colored_value(tr("dm_claws_des"), final_damage(damage), damage)
