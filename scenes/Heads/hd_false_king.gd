extends Head

func _ready() -> void:
	hd_name = tr("hd_false_king_name")
	description = tr("hd_false_king_des") % 45
	super()
	
func apply_passive_effect():
	ActionManager.add(DecreaseMaxHpAction.new(self, Global.hero, 45))
	ActionManager.play_one_action()
	
func turn_begin_add_action():
	ActionManager.add(BuffAction.new(self, Global.hero,StatusManager.repeat, 1))
	DominoManager.double_next_dm += 1
