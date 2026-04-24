@tool
extends Node2D

@onready var options_panel: Control = $OptionsPanel
@onready var color_rect: ColorRect = $ColorRect
@onready var sfx_label: Label = %SfxLabel
@onready var music_label: Label = %MusicLabel
@onready var options_button: IconButton = %OptionsButton

@export var visible_by_default := false:
	set(value):
		visible_by_default = value
		if is_instance_valid(options_panel):
			options_panel.visible = value
		if is_instance_valid(color_rect):
			color_rect.visible = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		options_panel.visible = false
		color_rect.visible = false
	else:
		options_panel.visible = visible_by_default
		color_rect.visible = visible_by_default
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
