class_name AttackWithoutAnim
extends Action

var damage:int

func _init(_target,_damage):
	#source = _source
	target = _target
	damage = _damage

func execute():
	target.take_damage(damage)
	AnimationManager.spawn_damage_label(damage, target)
	#AnimationManager.spawn_anim(AnimationManager.attack_anim, target, damage)
