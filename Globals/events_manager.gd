extends Node

var events := {}
var linked_events := {}

func _ready() -> void:
	#events["prisoner"] = preload("res://resources/events/Act1/Prisoner/prisoner.tres")
	#events["dragon_skeleton"] = preload("res://resources/events/DragonSkeleton/dragon_skeleton.tres")
	#events["the_curse_of_greed"] = preload("res://resources/events/TheCurseOfGreed/the_curse_of_greed.tres")
	events["vampire"] = preload("uid://x3pgrjneoybo")
	
	Global.load_templates("res://resources/linked_events", linked_events)
	#Global.load_templates("res://resources/events", events)
	pass
