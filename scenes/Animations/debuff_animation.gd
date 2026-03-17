extends Node2D


func _ready() -> void:
	Signals.play_status_sound.emit()
	await $AnimatedSprite2D.animation_finished
	queue_free()
