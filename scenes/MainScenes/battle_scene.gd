extends Node2D

@onready var characters = $Characters

func _ready() -> void:
	Global.fight_scene = self
