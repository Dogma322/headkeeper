extends HeadTemplate

func get_translated_desc() -> String:
	return tr("HD_CHAOS_DESC") % ['x', Constants.hd_chaos_damage_level_1]
