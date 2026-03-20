extends Node2D

@onready var options_panel = $OptionsPanel

@export var stage_label: Label
@export var sfx_label: Label
@export var music_label: Label
@export var end_run_btn: GameButton
@export var win_btn: GameButton

func _ready() -> void:
	options_panel.visible = false
	update_labels()


func _on_options_button_pressed() -> void:
	if options_panel.visible == false:
		update_labels()
		options_panel.visible = true
		DominoManager.block_domino_input = true
		$OptionsButton.texture_normal = load("res://assets/UI/OptionsMenu/ExitButton.png")
	else:
		options_panel.visible = false
		DominoManager.block_domino_input = false
		$OptionsButton.texture_normal = load("res://assets/UI/OptionsMenu/OptionsButton.png")


func _on_options_button_mouse_entered() -> void:
	$OptionsButton.modulate = Color(1.3,1.3,1.3)


func _on_options_button_mouse_exited() -> void:
	$OptionsButton.modulate = Color(1,1,1)


func update_labels():
	stage_label.text = tr("stage") % CombatManager.stage
	sfx_label.text = tr("sfx_volume")
	music_label.text = tr("music_volume")
	end_run_btn.text = tr("give_up")


func _on_end_run_btn_pressed() -> void:
	CombatManager.return_to_main_menu()


func _on_win_btn_pressed() -> void:
	if Global.enemy != null:
		Global.enemy.take_damage(Global.enemy.health)
