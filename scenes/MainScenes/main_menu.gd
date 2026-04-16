@tool
extends Control

@onready var play_btn: GameButton = %PlayBtn
@onready var change_board_generation_btn: GameButton = %ChangeBoardGenerationBtn

func _ready() -> void:
	play_btn.text = tr("play")
	change_board_generation_btn.text = "Рандомные поля: вкл"

	if not Engine.is_editor_hint():
		Transition.blackout_off()
		SoundManager.set_music("MainMenu")


func _on_map_btn_pressed() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	hide()
	SceneManager.new_run()


## Происходит при нажатии кнопки 'Играть'.
func _on_play_btn_pressed() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/MainScenes/battle_scene.tscn")
	Global.fight_scene.start()

## Происходит при нажатии кнопки 'Магазин'.
func _on_shop_btn_pressed() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/MainScenes/shop_scene.tscn")


func _on_craft_btn_pressed() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/MainScenes/craft_scene.tscn")


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
