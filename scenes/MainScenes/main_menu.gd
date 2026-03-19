extends Node2D

func _ready() -> void:
	Transition.blackout_off()
	SoundManager.set_music("MainMenu")
