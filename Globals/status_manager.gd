extends Node

var vulnerable = preload("res://resources/statuses/vulnerable.tres")




func apply_status(status,stacks,target):
	target.status_container.add_status(status.duplicate(), stacks)
