class_name AttackDebuffAction
extends Action

var damage:int
var status
var stacks


func _init(_source,_target,_damage,_status,_stacks):
	source = _source
	target = _target
	damage = _damage
	status = _status
	stacks = _stacks

func execute():
	target.take_damage(damage)
	target.status_container.add_status(status,stacks)
