class_name DecreaseMaxHpAction
extends Action

var damage:int

func _init(_source,_target,_damage):
	source = _source
	target = _target
	damage = _damage

func execute():
	target.max_health -= damage
	if target.health > target.max_health:
		target.health = target.max_health
	AnimationManager.spawn_anim(AnimationManager.debuff_anim, target, 0)
