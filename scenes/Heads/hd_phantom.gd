extends Head

func _ready() -> void:
	Signals.green_bonus_played.connect(play)
	damage = 2
	hd_name = tr("hd_phantom_name")
	description = tr("hd_phantom_des") % damage
	
	super()
	
func play(domino):
	add_action()
	
func add_action():
	ActionManager.add(AttackAction.new(self, Global.enemy, 2))
