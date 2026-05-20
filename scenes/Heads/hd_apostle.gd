extends Head

## Голова : Апостол

func _ready() -> void:
	Signals.skill_dm_played.connect(play)
	super()


func update_desc() -> void:
	if invert_logic:
		description = tr("HD_APOSTLE_DESC_ELITE") % [Constants.hd_apostle_corruption_to_hero]
	else:
		match level:
			1:
				description = tr("HD_APOSTLE_DESC2") % [Constants.hd_apostle_corruption_level_2 + DominoManager.corruption_bonus, Constants.hd_apostle_weak_level_2, Constants.hd_apostle_health_decrement]
			2:
				description = tr("HD_APOSTLE_DESC3") % [Constants.hd_apostle_corruption_level_3 + DominoManager.corruption_bonus, Constants.hd_apostle_weak_level_3, Constants.hd_apostle_vulnerable_level_3, Constants.hd_apostle_health_decrement]
			_:
				description = tr("HD_APOSTLE_DESC") % [Constants.hd_apostle_corruption_level_1 + DominoManager.corruption_bonus, Constants.hd_apostle_health_decrement]


func apply_passive_effect() -> void:
	if invert_logic:
		ActionManager.add(ChangeMaxHpAction.new(self, Global.hero, -Constants.hd_apostle_health_decrement))
	else:
		ActionManager.add(ChangeMaxHpAction.new(self, Global.hero, Constants.hd_apostle_health_decrement))
	ActionManager.play_one_action()


func play(_domino: Domino) -> void:
	add_action()


func add_action() -> void:
	if invert_logic:
		ActionManager.add(DebuffAction.new(self, Global.hero, StatusManager.corruption, Constants.hd_apostle_corruption_to_hero))
		return
	var amount := Constants.hd_apostle_corruption_level_1
	match level:
		1:
			amount = Constants.hd_apostle_corruption_level_2
		2:
			amount = Constants.hd_apostle_corruption_level_3
	ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.corruption, amount + DominoManager.corruption_bonus))
	match level:
		1:
			ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.weak, Constants.hd_apostle_weak_level_2))
		2:
			ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.weak, Constants.hd_apostle_weak_level_3))
			ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.vulnerable, Constants.hd_apostle_vulnerable_level_3))
