extends Head

var last_domino = null


func _ready() -> void:
	Signals._1dm_played.connect(chaos)
	Signals._2dm_played.connect(chaos)
	Signals._3dm_played.connect(chaos)
	Signals._4dm_played.connect(chaos)
	Signals.player_turn_begin.connect(reroll_value)
	super()


func update_desc() -> void:
	if invert_logic:
		description = tr("hd_chaos_des_elite") % value
	else:
		match level:
			1:
				description = tr("hd_chaos_des2") % value
			2:
				description = tr("hd_chaos_des3") % value
			_:
				description = tr("hd_chaos_des") % value


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
		amount = 2
	else:
		target = Global.enemy
		amount = 4
		match level:
			1:
				amount = 5
			2:
				amount = 6
	
	ActionManager.add(AttackAction.new(self, target, amount))
	
	if not invert_logic and level > 0:
		var choices = ["fury", "thorns", "draw"]
		var choice = choices.pick_random()
		
		match choice:
			"fury":
				ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.fury, level))
			"thorns":
				ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.thorns, level))
			"draw":
				ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.draw, level))
