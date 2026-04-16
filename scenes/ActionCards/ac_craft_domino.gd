extends ActionCard

func _ready() -> void:
	description = "Крафт"# tr("craft_mode") 
	super()
	
func effect():
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	var craft_scene_instance = Global.craft_scene.instantiate()
	Global.fight_scene.add_child(craft_scene_instance)
	await Signals.domino_selected
	craft_scene_instance.queue_free()
	SceneManager.show_map_scene()
