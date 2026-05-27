extends HeadTemplate

func get_translated_desc() -> String:
	return tr("HD_CORRUPTOR_DESC") % [Constants.hd_corruptor_corruption_level_1]
