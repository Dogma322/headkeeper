extends Node2D


func _ready() -> void:
	$Label.text = tr("block_damage")

func animate():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", (global_position + Vector2(0,-50)), 0.3)
	tween.tween_property(self, "modulate", Color(0,0,0,0), 0.3)
	await tween.finished
	queue_free()
