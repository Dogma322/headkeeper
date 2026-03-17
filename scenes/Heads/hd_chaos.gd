extends Head


var value = 1
var activated = false
var last_domino = null

func _ready() -> void:
	Signals._1dm_played.connect(chaos)
	Signals._2dm_played.connect(chaos)
	Signals._3dm_played.connect(chaos)
	Signals._4dm_played.connect(chaos)
	Signals.player_turn_begin.connect(reroll_value)
	
	
	hd_name = tr("hd_chaos_name")
	description = tr("hd_chaos_des") % value
	
	super()

func apply_passive_effect():
	label.visible = true
	label.text = str(value)



func reroll_value():
	value = randi_range(1, 4)
	description = tr("hd_chaos_des") % value
	label.text = str(value)
	#update_labels()
	
func head_selected():
	label.visible = true

func chaos(domino):
	if activated:
		return
	if last_domino == domino:
		return
	
	last_domino = domino
	activated = true
	
	if domino.a == value or domino.b == value:
		add_action()
	
	# сбросим флаг чуть позже (чтобы один кадр не схватил повторно)
	await get_tree().process_frame
	activated = false
	last_domino = null

	
	
func add_action():
	ActionManager.add(AttackAction.new(self, Global.enemy, 4))
