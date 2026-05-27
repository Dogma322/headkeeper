extends HeadTemplate

func get_translated_desc() -> String:
	return tr("HD_FALSE_KING_DESC") % [Constants.hd_false_king_health_decrement]
