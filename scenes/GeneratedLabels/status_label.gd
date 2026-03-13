extends Node2D

@onready var status_name
@onready var stacks

func _ready() -> void:
	$Label.text = str(status_name) + " " + str(stacks)

func animate():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", (global_position + Vector2(0,-30)), 0.4)
	tween.tween_property(self, "modulate", Color(0,0,0,0), 0.3)
	await tween.finished
	queue_free()
