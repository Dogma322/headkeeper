extends Node2D


func _ready() -> void:
	Signals.play_block_sound.emit()
	await $AnimatedSprite2D.animation_finished
	queue_free()
