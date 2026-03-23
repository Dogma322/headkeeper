extends Domino

func _ready() -> void:
	domino_types = ["Skill"]
	Signals._3dm_played.connect(play)
	super()

func play(domino: Domino):
	if domino == self:
		return
	if slot:
		add_action()

func add_action():
	ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.fury, 1))

	
func update_labels():
	await get_tree().process_frame
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("dm_horn_des") % 1)
