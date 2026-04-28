@tool
extends Control
class_name OptionsPanel

@onready var options_panel = $OptionsPanel
@onready var color_rect: ColorRect = $ColorRect
@onready var options_button: IconButton = %OptionsButton
@onready var stage_label: Label = %StageLabel
@onready var sfx_label: Label = %SfxLabel
@onready var music_label: Label = %MusicLabel
@onready var main_menu_box: VBoxContainer = %MainMenuBox
@onready var map_box: VBoxContainer = %MapBox
@onready var battle_box: VBoxContainer = %BattleBox
@onready var shop_box: VBoxContainer = %ShopBox
@onready var boxes = [main_menu_box, map_box, battle_box, shop_box]
@onready var free_choice_button: GameButton = %FreeChoiceButton
@onready var change_board_generation_btn: GameButton = %ChangeBoardGenerationBtn

func show_box(other_box = null):
	for box in boxes:
		if box == other_box:
			box.show()
		else:
			box.hide()

@export var visible_by_default := false:
	set(value):
		visible_by_default = value
		if is_instance_valid(options_panel):
			options_panel.visible = value
		if is_instance_valid(color_rect):
			color_rect.visible = value


func _ready() -> void:
	if not Engine.is_editor_hint():
		options_panel.visible = false
		color_rect.visible = false
	else:
		options_panel.visible = visible_by_default
		color_rect.visible = visible_by_default
	update_labels.call_deferred()
	change_board_generation_btn.text = "Рандомные поля: вкл"


func show_panel(enabled: bool) -> void:
	if enabled:
		update_labels()
		color_rect.visible = true
		options_panel.visible = true
		DominoManager.block_domino_input = true
		options_button.texture = load("res://assets/UI/OptionsMenu/ExitButton.png")
	else:
		color_rect.visible = false
		options_panel.visible = false
		DominoManager.block_domino_input = false
		options_button.texture = load("res://assets/UI/OptionsMenu/OptionsButton.png")


func _on_options_button_pressed() -> void:
	if Global.top_window != null:
		Global.top_window.hide()
		Global.top_window = null
		return
	
	if options_panel.visible == false:
		show_panel(true)
	else:
		show_panel(false)


func update_labels() -> void:
	if not Engine.is_editor_hint():
		stage_label.text = tr("stage") % CombatManager.stage
	sfx_label.text = tr("sfx_volume")
	music_label.text = tr("music_volume")


func _on_end_run_btn_pressed() -> void:
	CombatManager.return_to_main_menu()
	show_panel(false)


func _on_win_btn_pressed() -> void:
	if Global.enemy != null:
		Global.enemy.kill()
		show_panel(false)


func _on_gen_button_pressed() -> void:
	Global.map_scene.reset()


func _on_free_choice_button_pressed() -> void:
	Global.map_scene.free_choice_mode = !Global.map_scene.free_choice_mode
	if Global.map_scene.free_choice_mode:
		free_choice_button.text = "Свободный выбор: вкл"
	else:
		free_choice_button.text = "Свободный выбор: выкл"


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


func _on_add_money_btn_pressed() -> void:
	create_tween().tween_property(MoneyManager, "gold", MoneyManager.gold + 100, 0.25)


func _on_shop_gen_button_pressed() -> void:
	SceneManager.shop_scene.refill()
