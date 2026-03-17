extends Node2D

@onready var camera = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.play_damage_sound.connect(camera_shake)


func camera_shake():
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "zoom", Vector2(1.02, 1.02), 0.1)
	tween.tween_property(camera, "zoom", Vector2(1, 1), 0.2)
