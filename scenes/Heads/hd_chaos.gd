extends Head

## Голова : Хаос

var last_domino = null
var value := 0

func _ready() -> void:
	Signals._1dm_played.connect(chaos)
	Signals._2dm_played.connect(chaos)
	Signals._3dm_played.connect(chaos)
	Signals._4dm_played.connect(chaos)
	Signals.player_turn_begin.connect(reroll_value)
	super()


func update_desc() -> void:
	var val = "x" if value == 0 else str(value)
	
	if invert_logic:
		description = tr("HD_CHAOS_DESC_ELITE") % [val, Constants.hd_chaos_damage_to_hero]
	else:
		match level:
			0:
				description = tr("HD_CHAOS_DESC") % [val, Constants.hd_chaos_damage_level_1]
			1:
				description = tr("HD_CHAOS_DESC2") % [val, Constants.hd_chaos_damage_level_2]
			2:
				description = tr("HD_CHAOS_DESC3") % [val, Constants.hd_chaos_damage_level_3]


func apply_passive_effect() -> void:
	label.visible = true
	label.text = str(value)


func reroll_value() -> void:
	value = randi_range(1, 4)
	label.text = str(value)
	update_desc()
	#update_labels()


func head_selected() -> void:
	label.visible = true


func chaos(domino) -> void:
	if last_domino == domino:
		return
	
	last_domino = domino
	
	if domino.a == value or domino.b == value:
		add_action()
	
	# сбросим флаг чуть позже (чтобы один кадр не схватил повторно)
	await get_tree().process_frame
	last_domino = null


func add_action() -> void:
	var target = null
	var amount := 0
	
	if invert_logic:
		target = Global.hero
		amount = Constants.hd_chaos_damage_to_hero
	else:
		target = Global.enemy
		match level:
			1:
				amount = Constants.hd_apostle_corruption_level_2
			2:
				amount = Constants.hd_apostle_corruption_level_3
			_:
				amount = Constants.hd_apostle_corruption_level_1
	
	ActionManager.add(AttackAction.new(self, target, amount))
	
	if not invert_logic and level > 0:
		var choices = ["fury", "regen", "thorns", "draw"]
		var choice = choices.pick_random()
		
		match choice:
			"fury":
				ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.fury, level))
			"regen":
				ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.regen, level))
			"thorns":
				ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.thorns, level))
			"draw":
				ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.draw, level))
