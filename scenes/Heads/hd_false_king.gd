extends Head

func _ready() -> void:
	super()
	
func apply_passive_effect():
	ActionManager.add(ChangeMaxHpAction.new(self, Global.hero, value))
	ActionManager.play_one_action()
	
func turn_begin_add_action():
	ActionManager.add(BuffAction.new(self, Global.hero,StatusManager.repeat, 1))
	DominoManager.double_next_dm += 1
