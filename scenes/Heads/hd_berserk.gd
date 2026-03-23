extends Head

func _ready() -> void:
	Signals._3dm_played.connect(play)
	super()
	
func play(domino):
	add_action()
	
func add_action():
	ActionManager.add(AttackAction.new(self, Global.enemy, 3))
