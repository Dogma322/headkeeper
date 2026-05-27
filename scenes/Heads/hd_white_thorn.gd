extends Head

## Голова: Белый Шип

func battle_start_add_action() -> void:
	if not invert_logic and level == 2:
		ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.thorns, Constants.hd_white_thorn_startup_thorns_level_3))


func update_desc() -> void:
	if invert_logic:
		description = tr("HD_WHITE_THORN_DESC_ELITE")
	else:
		match level:
			0:
				description = tr("HD_WHITE_THORN_DESC")
			1:
				description = tr("HD_WHITE_THORN_DESC2")
			2:
				description = tr("HD_WHITE_THORN_DESC3") % [Constants.hd_white_thorn_startup_thorns_level_3]


func apply_passive_effect() -> void:
	if invert_logic:
		Global.enemy.bonus_pool.append(BoardManager.e_2thorns)
	else:
		BoardManager.bonus_pool.append(BoardManager.h_thorns)
		BoardManager.bonus_pool.append(BoardManager.h_thorns)

		match level:
			1:
				Global.hero.thorns_damage_mult = 2
			2:
				Global.hero.thorns_damage_mult = 2
	pass


func remove_passive_effect() -> void:
	if invert_logic:
		Global.enemy.bonus_pool.erase(BoardManager.e_2thorns)
	else:
		BoardManager.bonus_pool.erase(BoardManager.h_thorns)
		BoardManager.bonus_pool.erase(BoardManager.h_thorns)

		match level:
			1:
				Global.hero.thorns_damage_mult = 1
			2:
				Global.hero.thorns_damage_mult = 1
	pass
