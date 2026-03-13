extends Node

var vulnerable = preload("res://resources/statuses/vulnerable.tres")
var corruption = preload("res://resources/statuses/corruption.tres")




func apply_status(status,stacks,target):
	target.status_container.add_status(status.duplicate(), stacks)
