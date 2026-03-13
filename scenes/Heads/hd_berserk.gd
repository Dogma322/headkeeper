extends Head

func _ready() -> void:
	Signals._3dm_played.connect(play)
	hd_name = tr("hd_warrior_name")
	description = tr("hd_warrior_des") 
	
	super()
	
func play(domino):
	add_action()
	
func add_action():
	ActionManager.add(AttackAction.new(self, Global.enemy, 3))
