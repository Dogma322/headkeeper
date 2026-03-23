extends Domino

func _ready() -> void:
	domino_types = ["Attack"]
	damage = 3
	Signals.attack_dm_played.connect(play)
	super()

func play(domino: Domino):
	if domino == self:
		return
	if slot:
		add_action()

func add_action():
	ActionManager.add(AttackAction.new(self, Global.enemy, 3))
	
func update_labels():
	await get_tree().process_frame
	tooltip_panel.description = TextFormatter.insert_colored_value(tr("dm_spear_des"), final_damage(damage), damage)
