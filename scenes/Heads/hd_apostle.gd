extends Head

func _ready() -> void:
	Signals.skill_dm_played.connect(play)
	super()
	description = TextFormatter.highlight_keywords(tr("hd_octopus_des") % [(corruption + DominoManager.corruption_bonus), 20])


func apply_passive_effect():
	ActionManager.add(ChangeMaxHpAction.new(self, Global.hero, 20))
	ActionManager.play_one_action()


func play(domino):
	add_action()


func add_action():
	ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.corruption, 2 + DominoManager.corruption_bonus))
