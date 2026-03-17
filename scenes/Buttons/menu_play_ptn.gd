extends TextureButton

func _ready() -> void:
	$Label.text = tr("play")


func _on_pressed() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/MainScenes/battle_scene.tscn")


func _on_mouse_entered() -> void:
	modulate = Color(1.3,1.3,1.3)


func _on_mouse_exited() -> void:
	modulate = Color(1,1,1)
