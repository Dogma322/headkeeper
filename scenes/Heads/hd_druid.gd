extends Head

## Голова : Друид

func _ready() -> void:
	Signals.hero_healed.connect(add_action)
	super()


func update_desc() -> void:
	if invert_logic:
		description = tr("HD_DRUID_DESC_ELITE") % [Constants.hd_druid_fury_to_enemy]
	else:
		match level:
			0:
				description = tr("HD_DRUID_DESC") % [Constants.hd_druid_fury_level_1, Constants.hd_druid_health_decrement]
			1:
				description = tr("HD_DRUID_DESC2") % [Constants.hd_druid_fury_level_2, Constants.hd_druid_crit_level_2, Constants.hd_druid_health_decrement]
			2:
				description = tr("HD_DRUID_DESC2") % [Constants.hd_druid_fury_level_3, Constants.hd_druid_crit_level_3, Constants.hd_druid_health_decrement]


func apply_passive_effect() -> void:
	if invert_logic:
		ActionManager.add(ChangeMaxHpAction.new(self, Global.hero, -Constants.hd_druid_health_decrement))
	else:
		ActionManager.add(ChangeMaxHpAction.new(self, Global.hero, Constants.hd_druid_health_decrement))
	ActionManager.play_one_action()


func add_action() -> void:
	if invert_logic:
		ActionManager.add(BuffAction.new(self, Global.enemy, StatusManager.fury, 1))
	else:
		var fury = Constants.hd_druid_fury_level_1
		var crit = 0
		match level:
			1:
				fury = Constants.hd_druid_fury_level_2
				crit = Constants.hd_druid_crit_level_2
			2:
				fury = Constants.hd_druid_fury_level_3
				crit = Constants.hd_druid_crit_level_3
		ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.fury, fury))
		if crit > 0:
			ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.crit, crit))
