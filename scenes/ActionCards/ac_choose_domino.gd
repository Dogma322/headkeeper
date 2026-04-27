extends ActionCard

func _ready() -> void:
	description = "Выбор домино" #tr("choose_mode") 
	super()
	
func effect():
	SceneManager.main_scene = SceneManager.choice_scene
	SceneManager.show_choice_scene()
	
	Global.choice_scene.spawn_dominoes()
	await Signals.domino_selected
	await get_tree().create_timer(1.0).timeout
	
	Transition.blackout_on()
	await get_tree().create_timer(1.0).timeout
	Transition.blackout_off()
	
	SceneManager.main_scene = SceneManager.map_scene
	SceneManager.show_map_scene()
