@tool
extends Control
class_name MainMenu

@onready var play_btn: GameButton = %PlayBtn
@onready var change_board_generation_btn: GameButton = %ChangeBoardGenerationBtn

func _ready() -> void:
	play_btn.text = tr("play")
	change_board_generation_btn.text = "Рандомные поля: вкл"

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


## Происходит при нажатии кнопки 'Рандомные поля'.
func _on_change_board_generation_btn_pressed() -> void:
	if BoardManager.random_boards == true:
		BoardManager.random_boards = false
		BoardManager.reset_run()
		print("RANDOMBOARDS")
		change_board_generation_btn.text = "Рандомные поля: выкл"
	else:
		BoardManager.random_boards = true
		change_board_generation_btn.text = "Рандомные поля: вкл"
		BoardManager.reset_run()


func _on_exit_button_pressed() -> void:
	Global.save_settings()
	get_tree().quit()
