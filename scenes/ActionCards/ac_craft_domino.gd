extends ActionCard

func _ready() -> void:
	description = "Крафт"# tr("craft_mode") 
	super()
	
func effect():
	Transition.blackout_on()
	await get_tree().create_timer(1.0).timeout
	Transition.blackout_off()
	
	SceneManager.show_craft_scene()
	await Signals.domino_selected
	
	Transition.blackout_on()
	await get_tree().create_timer(1.0).timeout
	Transition.blackout_off()
	SceneManager.show_map_scene()
