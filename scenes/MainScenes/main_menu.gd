@tool
extends Control
class_name MainMenu

@onready var play_btn: GameButton = %PlayBtn

func _ready() -> void:
	play_btn.text = tr("play")

	if not Engine.is_editor_hint():
		Global.main_menu = self
		Transition.blackout_off()
		SoundManager.set_music("MainMenu")


## Происходит при нажатии кнопки 'Играть'.
func _on_play_btn_pressed() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	Transition.blackout_off()
	hide()
	SceneManager.new_run()


## Происходит при нажатии кнопки 'Мета'.
func _on_meta_btn_pressed() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	Transition.blackout_off()
	
	hide()
	SceneManager.main_scene = SceneManager.meta_scene
	SceneManager.show_meta_scene()


## Происходит при нажатии кнопки 'Крафт'.
func _on_craft_btn_pressed() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	Transition.blackout_off()
	
	hide()
	SceneManager.main_scene = SceneManager.craft_scene
	SceneManager.show_craft_scene()
	SceneManager.craft_scene.start_demo()


func _on_exit_button_pressed() -> void:
	Global.save_settings()
	get_tree().quit()
