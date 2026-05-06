extends Head

func _ready() -> void:
	Signals._dm_played.connect(play)
	super()


func _update_desc() -> void:
	if invert_logic:
		description = tr("hd_berserk_des_elite") % [Constants.hd_berserk_activator_value, Constants.hd_berserk_damage_to_hero]
	else:
		description = tr("hd_berserk_des") % [Constants.hd_berserk_activator_value, Constants.hd_berserk_damage_to_enemy]
		match level:
			1:
				description = tr("hd_berserk_des2") % [Constants.hd_berserk_activator_value, Constants.hd_berserk_damage_to_enemy, Constants.hd_berserk_fury_level_2]
			2:
				description = tr("hd_berserk_des3") % [Constants.hd_berserk_activator_value, Constants.hd_berserk_damage_to_enemy, Constants.hd_berserk_fury_level_3]


func play(count: int, _domino: Domino) -> void:
	if count == Constants.hd_berserk_activator_value:
		add_action()


func add_action() -> void:
	if invert_logic:
		ActionManager.add(AttackAction.new(self, Global.hero, Constants.hd_berserk_damage_to_hero))
	else:
		ActionManager.add(AttackAction.new(self, Global.enemy, Constants.hd_berserk_damage_to_enemy))
		match level:
			1:
				ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.fury, Constants.hd_berserk_fury_level_2))
			2:
				ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.fury, Constants.hd_berserk_fury_level_3))
