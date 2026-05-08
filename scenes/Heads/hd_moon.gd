extends Head

## Голова : Луна

var dm_counter = 0

func _ready() -> void:
	Signals.domino_played.connect(increase_counter)
	super()


func update_desc() -> void:
	if invert_logic:
		description = tr("hd_moon_des_elite") % [Constants.hd_moon_domino_activator_value, Constants.hd_moon_damage_to_hero]
	else:
		match level:
			1:
				description = tr("hd_moon_des2") % [Constants.hd_moon_domino_activator_value, Constants.hd_moon_damage_level_2, Constants.hd_moon_armor_level_2]
			2:
				description = tr("hd_moon_des3") % [Constants.hd_moon_domino_activator_value, Constants.hd_moon_damage_level_3, Constants.hd_moon_armor_level_3, Constants.hd_moon_draw_level_3]
			_:
				description = tr("hd_moon_des") % [Constants.hd_moon_domino_activator_value, Constants.hd_moon_damage_level_1]


func apply_passive_effect() -> void:
	label.visible = true
	label.text = str(dm_counter)


func increase_counter() -> void:
	dm_counter += 1
	label.text = str(dm_counter)
	
	if dm_counter == Constants.hd_moon_domino_activator_value:
		dm_counter = 0
		label.text = str(dm_counter)
		add_action()


func add_action() -> void:
	if invert_logic:
		ActionManager.add(AttackAction.new(self, Global.hero, Constants.hd_moon_damage_to_hero))
	else:
		match level:
			1:
				ActionManager.add(AttackAction.new(self, Global.enemy, Constants.hd_moon_damage_level_2))
				ActionManager.add(BlockAction.new(self, Global.hero, Constants.hd_moon_armor_level_2))
			2:
				ActionManager.add(AttackAction.new(self, Global.enemy, Constants.hd_moon_damage_level_3))
				ActionManager.add(BlockAction.new(self, Global.hero, Constants.hd_moon_armor_level_3))
			_:
				ActionManager.add(AttackAction.new(self, Global.enemy, Constants.hd_moon_damage_level_1))
