extends ActionCard

func _ready() -> void:
	description = "Выбор домино" #tr("choose_mode") 
	super()
	
func effect():
	SceneManager.show_choice_scene()
	Global.choice_scene.spawn_dominoes()
	await Signals.domino_selected
	await get_tree().create_timer(1.0).timeout
	SceneManager.show_map_scene(true)
