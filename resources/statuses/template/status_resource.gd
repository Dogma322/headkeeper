extends Resource
class_name StatusResource

signal status_applied(status: StatusResource)
signal status_changed

var name
var des

@export_group("Status Data")
@export var id: String
@export var reducible: bool
@export var stackable: bool
@export var can_go_negative: bool
@export var turn_begin_effect: bool
@export var turn_end_effect: bool
@export var event_based_effect: bool
@export var texture: Texture

var stacks: int: set = set_stacks
var mult: int = 1
var owner


func set_stacks(value):
	stacks = value
	status_changed.emit()


func end_turn_reduce():
	if reducible:
		stacks -= 1


func update_text():
	name = ""
	des = ""
