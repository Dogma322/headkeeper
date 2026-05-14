extends Head

## Голова : Ложный Король


func _ready() -> void:
	super()


func update_desc() -> void:
	if invert_logic:
		description = tr("hd_false_king_des_elite")
	else:
		match level:
			1:
				description = tr("hd_false_king_des2") % [Constants.hd_false_king_gold_level_2, Constants.hd_false_king_health_decrement]
			2:
				description = tr("hd_false_king_des2") % [Constants.hd_false_king_gold_level_3, Constants.hd_false_king_health_decrement]
			_:
				description = tr("hd_false_king_des") % [Constants.hd_false_king_health_decrement]


func apply_passive_effect() -> void:
	if not used:
		used = true
		
		var gold := 0
		match level:
			1:
				gold = Constants.hd_false_king_gold_level_2
			2:
				gold = Constants.hd_false_king_gold_level_3
		Run.gold += gold
	
	if invert_logic:
		ActionManager.add(ChangeMaxHpAction.new(self, Global.hero, -Constants.hd_false_king_health_decrement))
	else:
		ActionManager.add(ChangeMaxHpAction.new(self, Global.hero, Constants.hd_false_king_health_decrement))
	ActionManager.play_one_action()


func turn_begin_add_action() -> void:
	if invert_logic:
		Global.hero.domino_ignore_count += 1
		return
	ActionManager.add(BuffAction.new(self, Global.hero,StatusManager.repeat, 1))
	DominoManager.double_next_dm += 1
