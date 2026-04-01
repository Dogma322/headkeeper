extends StatusResource

func update_text():
	name = tr("st_strength_name")
	if stacks > 0:
		des = tr("st_strength_in_game_des") % stacks
	else:
		des = tr("st_negative_strength_in_game_des") % abs(stacks)
