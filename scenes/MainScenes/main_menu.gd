@tool
extends Node2D

@onready var play_btn: GameButton = %PlayBtn
@onready var change_board_generation_btn: GameButton = %ChangeBoardGenerationBtn

func _ready() -> void:
	play_btn.text = tr("play")
	change_board_generation_btn.text = "Рандомные поля: вкл"

	if not Engine.is_editor_hint():
		Transition.blackout_off()
		SoundManager.set_music("MainMenu")
	


## Происходит при нажатии кнопки 'Играть'.
func _on_play_btn_pressed() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/MainScenes/battle_scene.tscn")


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
