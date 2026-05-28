extends Node

var events := {}

func _ready() -> void:
	Global.load_templates("res://resources/events", events)
	pass
