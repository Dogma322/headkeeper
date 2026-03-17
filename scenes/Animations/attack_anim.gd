extends Node2D


func _ready() -> void:
	#Signals.play_damage_sound.emit()
	#сигнал в действиях годот выдает ошибку если сюда вставить
	await $AnimatedSprite2D.animation_finished
	queue_free()
