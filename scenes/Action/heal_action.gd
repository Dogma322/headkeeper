class_name HealAction
extends Action

var heal

func _init(_source,_target,_heal):
	source = _source
	target = _target
	heal = _heal

func execute():
	target.take_heal(heal)
	AnimationManager.spawn_anim(AnimationManager.heal_anim, target, heal)
	AnimationManager.spawn_heal_label(heal, target)
