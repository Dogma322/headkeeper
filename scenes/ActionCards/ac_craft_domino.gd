extends ActionCard

func _ready() -> void:
	description = "Крафт"# tr("craft_mode") 
	super()
	
func effect():
	SceneManager.show_craft_scene()
	await Signals.domino_selected
	SceneManager.show_map_scene(true)
