extends Domino

func _ready() -> void:
	domino_types = ["Defense"]
	block = 3
	Signals.defense_dm_played.connect(play)
	super()

func play(domino: Domino):
	if domino == self:
		return
	if slot:
		add_action()

func add_action():
	ActionManager.add(BlockAction.new(self, Global.hero, 3))
	
func update_labels():
	await get_tree().process_frame
	tooltip_panel.description = TextFormatter.insert_colored_value(tr("dm_steel_shield_des"), final_block(block), block)
