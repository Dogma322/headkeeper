extends Domino

func _ready() -> void:
	domino_types = ["Skill"]
	corruption = 2
	Signals.skill_dm_played.connect(play)
	super()

func play(domino: Domino):
	if domino == self:
		return
	if slot:
		add_action()

func add_action():
	ActionManager.add(DebuffAction.new(self, Global.enemy,StatusManager.corruption, 2))
	
func update_labels():
	await get_tree().process_frame
	tooltip_panel.description = TextFormatter.insert_colored_value(tr("dm_dark_sphere_des"), final_corruption(corruption), corruption)
