extends StatusResource

func apply_status_effect():
	DominoManager.bonus_draw_counter += stacks
	stacks = 0

func update_text():
	name = tr("st_draw_name")
	des = tr("st_draw_in_game_des") % stacks
