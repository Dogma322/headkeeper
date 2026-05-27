extends HeadTemplate

func get_translated_desc() -> String:
	return tr("HD_DRUID_DESC") % [Constants.hd_druid_fury_level_1, Constants.hd_druid_health_decrement]
