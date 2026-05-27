extends HeadTemplate

func get_translated_desc() -> String:
	return tr("HD_MAW_DESC") % [Constants.hd_maw_health_decrement]
