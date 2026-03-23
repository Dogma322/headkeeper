extends Domino

func _ready() -> void:
	domino_types = ["Skill", "Defense"]
	block = 2
	Signals._2dm_played.connect(play)
	super()

func play(domino: Domino):
	if domino == self:
		return
	if slot:
		add_action()

func add_action():
	ActionManager.add(BlockAction.new(self, Global.hero, 2))
	ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.thorns, 2))

	
func update_labels():
	await get_tree().process_frame
	tooltip_panel.description = TextFormatter.insert_colored_value(tr("dm_thorned_shield_des"), final_block(block), block)
