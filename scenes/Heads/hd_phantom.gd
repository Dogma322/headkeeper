extends Head

func _ready() -> void:
	Signals.green_bonus_played.connect(play)
	super()
	
func play():
	add_action()
	
func add_action():
	ActionManager.add(AttackAction.new(self, Global.enemy, 2))
