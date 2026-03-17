extends Head

func _ready() -> void:
	Signals.defense_dm_played.connect(play)
	hd_name = tr("hd_rock_name")
	description = tr("hd_rock_des") % 15
	super()
	
func apply_passive_effect():
	ActionManager.add(DecreaseMaxHpAction.new(self, Global.hero, 15))
	ActionManager.play_one_action()
	
func play(domino):
	add_action()
	
func add_action():
	ActionManager.add(BlockAction.new(self, Global.hero, 2))
