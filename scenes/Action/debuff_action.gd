class_name DebuffAction
extends Action

var status
var stacks

func _init(_source,_target,_status,_stacks):
	source = _source
	target = _target
	status = _status
	stacks = _stacks

func execute():
	StatusManager.apply_status(status, stacks, target)
	AnimationManager.spawn_anim(AnimationManager.debuff_anim, target, 0)
	AnimationManager.spawn_status_label(target, status.name, stacks)
