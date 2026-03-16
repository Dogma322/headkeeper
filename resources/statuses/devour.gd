extends StatusResource

func update_text():
	name = tr("st_devour_name")
	des = TextFormatter.highlight_keywords(tr("st_devour_in_game_des"))
