extends HeadTemplate

func get_translated_desc() -> String:
	return tr("HD_APOSTLE_DESC") % [Constants.hd_apostle_corruption_level_1, Constants.hd_apostle_health_decrement]
