extends Head

var last_domino = null


func _ready() -> void:
	Signals._1dm_played.connect(chaos)
	Signals._2dm_played.connect(chaos)
	Signals._3dm_played.connect(chaos)
	Signals._4dm_played.connect(chaos)
	Signals.player_turn_begin.connect(reroll_value)
	super()


func _update_desc():
	if invert_logic:
		description = tr("hd_chaos_des_elite") % value
	else:
		description = tr("hd_chaos_des") % value


func apply_passive_effect():
	label.visible = true
	label.text = str(value)


func reroll_value():
	value = randi_range(1, 4)
	label.text = str(value)
	_update_desc()
	#update_labels()


func head_selected():
	label.visible = true


func chaos(domino):
	if last_domino == domino:
		return
	
	last_domino = domino
	
	if domino.a == value or domino.b == value:
		add_action()
	
	# сбросим флаг чуть позже (чтобы один кадр не схватил повторно)
	await get_tree().process_frame
	last_domino = null


func add_action():
	var target = null
	var damage := 0
	
	if invert_logic:
		target = Global.hero
		damage = 2
	else:
		target = Global.enemy
		damage = 4
	
	ActionManager.add(AttackAction.new(self, target, damage))
