extends Control
class_name MapScene

@onready var map: Map = $Map

func _ready() -> void:
	Transition.blackout_off()

func _on_exit_button_pressed() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/MainScenes/main_menu.tscn")


func _on_gen_button_pressed() -> void:
	map.generate()
