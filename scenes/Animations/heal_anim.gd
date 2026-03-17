extends Node2D


func _ready() -> void:
	Signals.play_heal_sound.emit()
	await $AnimatedSprite2D.animation_finished
	queue_free()
