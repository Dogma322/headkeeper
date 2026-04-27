extends Control
class_name ScreenBase

var top_panel_button: IconButton = null

func start() -> void:
	Foreground.options_panel.show_box()

func end() -> void:
	pass
