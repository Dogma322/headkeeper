extends Head

func _ready() -> void:
	Signals.defense_dm_played.connect(play)
	super()


func _update_desc() -> void:
	if invert_logic:
		description = tr("hd_rock_des_elite") % [Constants.hd_rock_armor_per_action_to_enemy]
	else:
		description = tr("hd_rock_des") % [Constants.hd_rock_armor_per_action_to_hero_level_1, Constants.hd_rock_health_decrement]
		match level:
			1:
				description = tr("hd_rock_des2") % [Constants.hd_rock_armor_per_action_to_hero_level_2, Constants.hd_rock_health_decrement]
			2:
				description = tr("hd_rock_des3") % [Constants.hd_rock_armor_per_action_to_hero_level_3, Constants.hd_rock_health_decrement]


func apply_passive_effect() -> void:
	ActionManager.add(ChangeMaxHpAction.new(self, Global.hero, -Constants.hd_rock_health_decrement if invert_logic else Constants.hd_rock_health_decrement))
	ActionManager.play_one_action()

	if not invert_logic:
		match level:
			1:
				ActionManager.add(BlockAction.new(self, Global.hero, Constants.hd_rock_armor_level_2))
				ActionManager.play_one_action()
			2:
				ActionManager.add(BlockAction.new(self, Global.hero, Constants.hd_rock_armor_level_3))
				ActionManager.play_one_action()


func play(_domino: Domino) -> void:
	add_action()


func add_action() -> void:
	if invert_logic:
		ActionManager.add(BlockAction.new(self, Global.hero, Constants.hd_rock_armor_per_action_to_enemy))
	else:
		match level:
			0:
				ActionManager.add(BlockAction.new(self, Global.hero, Constants.hd_rock_armor_per_action_to_hero_level_1))
			1:
				ActionManager.add(BlockAction.new(self, Global.hero, Constants.hd_rock_armor_per_action_to_hero_level_2))
			3:
				ActionManager.add(BlockAction.new(self, Global.hero, Constants.hd_rock_armor_per_action_to_hero_level_3))
