extends HeadTemplate

func get_translated_desc() -> String:
	return tr("HD_ROCK_DESC") % [Constants.hd_rock_armor_per_action_to_hero_level_1, Constants.hd_rock_health_decrement]
