extends Control

@onready var exit_button: TextureButton = %ExitButton

func _ready() -> void:
	Transition.blackout_off()


func _on_exit_button_pressed() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/MainScenes/main_menu.tscn")


func _on_exit_button_mouse_entered() -> void:
	exit_button.modulate = Color(1.3,1.3,1.3)


func _on_exit_button_mouse_exited() -> void:
	exit_button.modulate = Color(1,1,1)
