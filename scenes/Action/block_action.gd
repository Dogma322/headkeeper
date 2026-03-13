class_name BlockAction
extends Action

var block:int

func _init(_source,_target,_block):
	source = _source
	target = _target
	block = _block

func execute():
	target.take_block(block)
	AnimationManager.spawn_anim(AnimationManager.armor_anim, target, block)
