extends Domino

func _ready() -> void:
	domino_types = ["Attack"]
	damage = 8
	Signals.hero_healed.connect(play)
	super()

func play():
	if slot:
		add_action()

func add_action():
	ActionManager.add(AttackAction.new(self, Global.enemy, 8))
	
func update_labels():
	await get_tree().process_frame
	des_label.text = TextFormatter.insert_colored_value(tr("dm_dagger_des"), final_damage(damage), damage)
