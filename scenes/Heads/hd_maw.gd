extends Head

## Голова : Пасть

func _ready() -> void:
	super()


func update_desc() -> void:
	if invert_logic:
		description = tr("HD_MAW_DESC_ELITE") % [Constants.hd_maw_fury_to_enemy, Constants.hd_maw_health_decrement]
	else:
		match level:
			0:
				description = tr("HD_MAW_DESC") % [Constants.hd_maw_health_decrement]
			1:
				description = tr("HD_MAW_DESC2") % [Constants.hd_maw_fury_level_2, Constants.hd_maw_health_decrement]
			2:
				description = tr("HD_MAW_DESC2") % [Constants.hd_maw_fury_level_3, Constants.hd_maw_health_decrement]


## Происходит при начале хода в начале боя.
func battle_start_add_action() -> void:
	if invert_logic:
		ActionManager.add(BuffAction.new(self, Global.enemy, StatusManager.fury, Constants.hd_maw_fury_to_enemy))
	else:
		match level:
			1:
				ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.fury, Constants.hd_maw_fury_level_2))
			2:
				ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.fury, Constants.hd_maw_fury_level_3))


func apply_passive_effect() -> void:
	if invert_logic:
		ActionManager.add(ChangeMaxHpAction.new(self, Global.enemy, -Constants.hd_maw_health_decrement))
	else:
		ActionManager.add(ChangeMaxHpAction.new(self, Global.hero, Constants.hd_maw_health_decrement))
	ActionManager.play_one_action()
	
	if not invert_logic:
		BoardManager.bonus_pool.append(BonusManager.bonus_effects.h_1crit)
		BoardManager.bonus_pool.append(BonusManager.bonus_effects.h_1crit)
		BoardManager.bonus_pool.append(BonusManager.bonus_effects.h_1crit)


func remove_passive_effect() -> void:
	if not invert_logic:
		BoardManager.bonus_pool.erase(BonusManager.bonus_effects.h_1crit)
		BoardManager.bonus_pool.erase(BonusManager.bonus_effects.h_1crit)
		BoardManager.bonus_pool.erase(BonusManager.bonus_effects.h_1crit)
