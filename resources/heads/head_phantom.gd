extends HeadTemplate

func get_translated_desc() -> String:
	return tr("HD_PHANTOM_DESC") % [Constants.hd_phantom_damage_level_1]
