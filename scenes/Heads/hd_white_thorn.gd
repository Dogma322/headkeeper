extends Head

## Голова: Белый Шип


func battle_start_add_action() -> void:
	if not invert_logic and level == 2:
		ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.thorns, 6))


func update_desc() -> void:
	if invert_logic:
		description = tr("hd_thorn_des_elite")
	else:
		match level:
			1:
				description = tr("hd_thorn_des2")
			2:
				description = tr("hd_thorn_des3")
			_:
				description = tr("hd_thorn_des")


func apply_passive_effect() -> void:
	if invert_logic:
		Global.enemy.bonus_pool.append(BoardManager.e_2thorns)
	else:
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
		match level:
			1:
				Global.hero.thorns_damage_mult = 1
			2:
				Global.hero.thorns_damage_mult = 1
	pass
