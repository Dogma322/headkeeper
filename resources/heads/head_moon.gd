extends HeadTemplate

func get_translated_desc() -> String:
	return tr("HD_MOON_DESC") % [Constants.hd_moon_domino_activator_value, Constants.hd_moon_damage_level_1]
