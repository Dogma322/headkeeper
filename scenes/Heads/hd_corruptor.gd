extends Head

## Голова : Осквернитель


func _ready() -> void:
	super()


func update_desc() -> void:
	if invert_logic:
		description = tr("HD_CORRUPTOR_DESC_ELITE") % [Constants.hd_corruptor_corruption_to_hero]
	else:
		match level:
			1:
				description = tr("HD_CORRUPTOR_DESC2") % [Constants.hd_corruptor_corruption_level_2, Constants.hd_corruptor_damage_level_2]
			2:
				description = tr("HD_CORRUPTOR_DESC2") % [Constants.hd_corruptor_corruption_level_3, Constants.hd_corruptor_damage_level_3]
			_:
				description = tr("HD_CORRUPTOR_DESC") % [Constants.hd_corruptor_corruption_level_1]
	pass


func battle_start_add_action() -> void:
	if invert_logic:
		ActionManager.add(DebuffAction.new(self, Global.hero, StatusManager.corruption, Constants.hd_corruptor_corruption_to_hero))
	pass


func apply_passive_effect() -> void:
	if invert_logic:
		return
	var bonus = Constants.hd_corruptor_corruption_level_1
	match level:
		1:
			bonus = Constants.hd_corruptor_corruption_level_2
		2:
			bonus = Constants.hd_corruptor_corruption_level_3
	DominoManager.corruption_bonus += bonus
	pass


func remove_passive_effect() -> void:
	if invert_logic:
		return
	var bonus = Constants.hd_corruptor_corruption_level_1
	match level:
		1:
			bonus = Constants.hd_corruptor_corruption_level_2
		2:
			bonus = Constants.hd_corruptor_corruption_level_3
	DominoManager.corruption_bonus -= bonus
	pass
