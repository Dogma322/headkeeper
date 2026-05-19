extends StatusResource

func update_text():
	name = tr("st_repeat_bonus_name")
	des = tr("st_repeat_bonus_in_game_des") % [stacks + 1]
