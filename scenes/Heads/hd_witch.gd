extends Head

## Голова Ведьмы (событийная голова)

func _ready() -> void:
	pass

func update_desc() -> void:
	if invert_logic:
		description = tr("HD_CURSED_WITCH_DESC_ELITE") % [Constants.hd_cursed_witch_debuff, Constants.hd_cursed_witch_debuff]
	else:
		match level:
			0:
				description = tr("HD_CURSED_WITCH_DESC") % [Constants.hd_cursed_witch_buff_level_1, Constants.hd_cursed_witch_buff_level_1]
			1:
				description = tr("HD_CURSED_WITCH_DESC") % [Constants.hd_cursed_witch_buff_level_2, Constants.hd_cursed_witch_buff_level_2]
			2:
				description = tr("HD_CURSED_WITCH_DESC") % [Constants.hd_cursed_witch_buff_level_3, Constants.hd_cursed_witch_buff_level_3]
