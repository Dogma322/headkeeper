extends Node

var events := {}

func _ready() -> void:
	#events["dragon_skeleton"] = preload("res://resources/events/DragonSkeleton/dragon_skeleton.tres")
	events["the_curse_of_greed"] = preload("res://resources/events/TheCurseOfGreed/the_curse_of_greed.tres")
	#Global.load_templates("res://resources/events", events)
	pass
