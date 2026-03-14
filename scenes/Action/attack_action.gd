class_name AttackAction
extends Action

var damage:int

func _init(_source,_target,_damage):
	source = _source
	target = _target
	damage = _damage

func execute():
	var final_damage = damage
	
	if source is Domino:
		final_damage = ActionManager.calculate_damage(source, target, damage)
		
	target.take_damage(final_damage)
	AnimationManager.spawn_damage_label(final_damage, target)
	AnimationManager.spawn_anim(AnimationManager.attack_anim, target, final_damage)
	
	if source is Domino:
		Signals.deal_hero_thorn_damage.emit()
	if source is Enemy:
		Signals.deal_enemy_thorn_damage.emit()
