class_name CorruptedStuffAction
extends Action

var status
var stacks

func _init(_source,_target):
	source = _source
	target = _target

func execute():
	status = StatusManager.corruption
	stacks = DominoManager.value1_played_dominoes + DominoManager.corruption_bonus
	
	StatusManager.apply_status(status, stacks, target)
	AnimationManager.spawn_anim(AnimationManager.debuff_anim, target, 0)
	status.update_text()
	AnimationManager.spawn_status_label(target, status.name, stacks)
