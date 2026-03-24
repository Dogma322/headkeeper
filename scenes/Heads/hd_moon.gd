extends Head

var dm_counter = 0

func _ready() -> void:
	Signals.domino_played.connect(increase_counter)
	super()
	
func apply_passive_effect():
	label.visible = true
	label.text = str(dm_counter)
	
func increase_counter():
	dm_counter += 1
	label.text = str(dm_counter)
	
	if dm_counter == 8:
		dm_counter = 0
		label.text = str(dm_counter)
		add_action()
	
func add_action():
	ActionManager.add(AttackAction.new(self, Global.enemy, damage))
