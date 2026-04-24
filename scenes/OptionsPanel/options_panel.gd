@tool
extends Control
class_name OptionsPanel

@onready var options_panel = $OptionsPanel
@onready var color_rect: ColorRect = $ColorRect
@onready var options_button: IconButton = %OptionsButton
@onready var stage_label: Label = %StageLabel
@onready var sfx_label: Label = %SfxLabel
@onready var music_label: Label = %MusicLabel
@onready var win_btn: GameButton = %WinBtn
@onready var end_run_btn: GameButton = %EndRunBtn
@onready var map_box: VBoxContainer = %MapBox
@onready var battle_box: VBoxContainer = %BattleBox
@onready var boxes = [map_box, battle_box]
@onready var free_choice_button: GameButton = %FreeChoiceButton

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
	if options_panel.visible == false:
		show_panel(true)
	else:
		show_panel(false)


func update_labels() -> void:
	if not Engine.is_editor_hint():
		stage_label.text = tr("stage") % CombatManager.stage
	sfx_label.text = tr("sfx_volume")
	music_label.text = tr("music_volume")
	end_run_btn.text = tr("give_up")


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
