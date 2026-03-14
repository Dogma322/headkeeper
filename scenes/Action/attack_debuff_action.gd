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
	var final_damage = damage
	
	if source is Domino:
		final_damage = ActionManager.calculate_damage(source, target, damage)
		
	target.take_damage(final_damage)
	AnimationManager.spawn_damage_label(final_damage, target)
	AnimationManager.spawn_anim(AnimationManager.attack_anim, target, final_damage)
	
	
	AnimationManager.spawn_status_label(target, status.name_key, stacks)
	StatusManager.apply_status(status, stacks, target)
	
	
	if source is Domino:
		Signals.deal_hero_thorn_damage.emit()
	if source is Enemy:
		Signals.deal_enemy_thorn_damage.emit()
