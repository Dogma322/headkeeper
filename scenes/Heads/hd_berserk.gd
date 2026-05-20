extends Head

## Голова : Берсерк

func _ready() -> void:
	Signals._dm_played.connect(play)
	super()


func update_desc() -> void:
	if invert_logic:
		description = tr("HD_BERSERK_DESC_ELITE") % [Constants.hd_berserk_activator_value, Constants.hd_berserk_damage_to_hero]
	else:
		match level:
			1:
				description = tr("HD_BERSERK_DESC2") % [Constants.hd_berserk_activator_value, Constants.hd_berserk_damage_to_enemy, Constants.hd_berserk_fury_level_2]
			2:
				description = tr("HD_BERSERK_DESC2") % [Constants.hd_berserk_activator_value, Constants.hd_berserk_damage_to_enemy, Constants.hd_berserk_fury_level_3]
			_:
				description = tr("HD_BERSERK_DESC") % [Constants.hd_berserk_activator_value, Constants.hd_berserk_damage_to_enemy]


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
