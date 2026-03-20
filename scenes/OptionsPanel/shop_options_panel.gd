@tool
extends Node2D

@onready var options_panel: Control = $OptionsPanel
@onready var color_rect: ColorRect = $ColorRect
@onready var sfx_label: Label = %SfxLabel
@onready var music_label: Label = %MusicLabel
@onready var options_button: TextureButton = %OptionsButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		options_panel.visible = false
		color_rect.visible = false
	update_labels()

func update_labels():
	sfx_label.text = tr("sfx_volume")
	music_label.text = tr("music_volume")


func _on_options_button_pressed() -> void:
	if options_panel.visible == false:
		update_labels()
		color_rect.visible = true
		options_panel.visible = true
		options_button.texture_normal = load("res://assets/UI/OptionsMenu/ExitButton.png")
	else:
		color_rect.visible = false
		options_panel.visible = false
		options_button.texture_normal = load("res://assets/UI/OptionsMenu/OptionsButton.png")


func _on_options_button_mouse_entered() -> void:
	options_button.modulate = Color(1.3,1.3,1.3)


func _on_options_button_mouse_exited() -> void:
	options_button.modulate = Color(1,1,1)
