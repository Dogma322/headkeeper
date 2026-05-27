extends HeadTemplate

func get_translated_desc() -> String:
	return tr("HD_BERSERK_DESC") % [Constants.hd_berserk_activator_value, Constants.hd_berserk_damage_to_enemy]
