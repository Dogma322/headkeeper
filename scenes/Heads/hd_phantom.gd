extends Head

## Голова : Фантом

func _ready() -> void:
	Signals.green_bonus_played.connect(play)
	super()


func update_desc() -> void:
	if invert_logic:
		description = tr("HD_PHANTOM_DESC_ELITE") % [Constants.hd_phantom_damage_to_hero]
	else:
		match level:
			1:
				description = tr("HD_PHANTOM_DESC2") % [Constants.hd_phantom_damage_level_2]
			2:
				description = tr("HD_PHANTOM_DESC3") % [Constants.hd_phantom_damage_level_3]
			_:
				description = tr("HD_PHANTOM_DESC") % [Constants.hd_phantom_damage_level_1]
	pass


func play() -> void:
	add_action()


func add_action() -> void:
	if invert_logic:
		ActionManager.add(AttackAction.new(self, Global.hero, Constants.hd_phantom_damage_to_hero))
	else:
		var amount := Constants.hd_phantom_damage_level_1
		match level:
			1:
				amount = Constants.hd_phantom_damage_level_2
			2:
				amount = Constants.hd_phantom_damage_level_3
		ActionManager.add(AttackAction.new(self, Global.enemy, amount))


func turn_begin_add_action() -> void:
	if invert_logic or level < 1:
		return
	ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.repeat_bonus, level))


func turn_end_add_action() -> void:
	if invert_logic or level < 1:
		return
	Global.hero.	status_container.remove_status(StatusManager.repeat_bonus)
