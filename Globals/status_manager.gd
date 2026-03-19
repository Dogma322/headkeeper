extends Node

var vulnerable = preload("res://resources/statuses/vulnerable.tres")
var corruption = preload("res://resources/statuses/corruption.tres")
var thorns = preload("res://resources/statuses/thorns.tres")
var weak = preload("res://resources/statuses/weak.tres")
var invincible = preload("res://resources/statuses/invincible.tres")
var evasion = preload("res://resources/statuses/evasion.tres")
var draw = preload("res://resources/statuses/draw.tres")
var fury = preload("res://resources/statuses/fury.tres")
var repeat = preload("res://resources/statuses/repeat.tres")
var crit = preload("res://resources/statuses/crit.tres")
var devour = preload("res://resources/statuses/devour.tres")


#func apply_status(status, stacks, target):
#
	#var new_status = status.duplicate(true)
	#new_status.stacks = stacks
	#target.status_container.add_status(new_status, stacks)




func apply_status(status,stacks,target):
	target.status_container.add_status(status.duplicate(true), stacks)
