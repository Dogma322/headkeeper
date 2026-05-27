extends Head

## Голова : Хранитель

func _ready() -> void:
	super()


## Происходит при начале хода в начале боя.
func battle_start_add_action() -> void:
	if not invert_logic:
		match level:
			1:
				ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.regen, Constants.hd_warden_regen_level_2))
			2:
				ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.regen, Constants.hd_warden_regen_level_3))


func update_desc() -> void:
	if invert_logic:
		description = tr("HD_WARDEN_DESC_ELITE")
	else:
		match level:
			0:
				description = tr("HD_WARDEN_DESC") % [Constants.hd_warden_max_hp_increment_level_1]
			1:
				description = tr("HD_WARDEN_DESC2") % [Constants.hd_warden_regen_level_2, Constants.hd_warden_max_hp_increment_level_2]
			2:
				description = tr("HD_WARDEN_DESC2") % [Constants.hd_warden_regen_level_3, Constants.hd_warden_max_hp_increment_level_3]


func apply_passive_effect() -> void:
	if invert_logic:
		match level:
			0:
				ActionManager.add(ChangeMaxHpAction.new(self, Global.hero, -Constants.hd_warden_max_hp_increment_level_1))
			1:
				ActionManager.add(ChangeMaxHpAction.new(self, Global.hero, -Constants.hd_warden_max_hp_increment_level_2))
			2:
				ActionManager.add(ChangeMaxHpAction.new(self, Global.hero, -Constants.hd_warden_max_hp_increment_level_3))
	else:
		match level:
			0:
				ActionManager.add(ChangeMaxHpAction.new(self, Global.hero, Constants.hd_warden_max_hp_increment_level_1))
			1:
				ActionManager.add(ChangeMaxHpAction.new(self, Global.hero, Constants.hd_warden_max_hp_increment_level_2))
			2:
				ActionManager.add(ChangeMaxHpAction.new(self, Global.hero, Constants.hd_warden_max_hp_increment_level_3))
	ActionManager.play_one_action()
	
	if invert_logic:
		Global.enemy.bonus_pool.append(BoardManager.e_5heal)
		Global.enemy.bonus_pool.append(BoardManager.e_5heal)
		Global.enemy.bonus_pool.append(BoardManager.e_5heal)
	else:
		BoardManager.bonus_pool.append(BonusManager.bonus_effects.h_3heal)
		BoardManager.bonus_pool.append(BonusManager.bonus_effects.h_3heal)
		BoardManager.bonus_pool.append(BonusManager.bonus_effects.h_3heal)



func remove_passive_effect() -> void:
	if invert_logic:
		Global.enemy.bonus_pool.erase(BoardManager.e_5heal)
		Global.enemy.bonus_pool.erase(BoardManager.e_5heal)
		Global.enemy.bonus_pool.erase(BoardManager.e_5heal)
	else:
		BoardManager.bonus_pool.erase(BonusManager.bonus_effects.h_3heal)
		BoardManager.bonus_pool.erase(BonusManager.bonus_effects.h_3heal)
		BoardManager.bonus_pool.erase(BonusManager.bonus_effects.h_3heal)
