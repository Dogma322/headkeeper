extends Control
class_name ScreenBase

var top_panel_button: IconButton = null

func start() -> void:
	Foreground.options_panel.show_box()

func before_end() -> void:
	pass

func end() -> void:
	pass
