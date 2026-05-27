extends HeadTemplate

func get_translated_desc() -> String:
	return tr("HD_WARDEN_DESC") % [Constants.hd_warden_max_hp_increment_level_1]
