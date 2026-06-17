class_name AttackDebuffAction
extends Action

var damage: int = 0
var status
var stacks: int = 0


func _init(_source, _target, _damage: int, _status, _stacks: int) -> void:
	source = _source
	target = _target
	damage = _damage
	status = _status
	stacks = _stacks

func execute() -> void:
	var final_damage = damage
	
	if source is Domino:
		final_damage = ActionManager.final_calculate_damage(source, target, damage)
		
	target.take_damage(final_damage)
	AnimationManager.spawn_anim(AnimationManager.attack_anim, target, final_damage)
	Signals.play_damage_sound.emit()
	
	status.update_text()
	AnimationManager.spawn_status_label(target, status.name, stacks)
	StatusManager.apply_status(status, stacks, target)
	
	if source is Domino:
		Signals.deal_hero_thorn_damage.emit()
	if source is Enemy:
		Signals.deal_enemy_thorn_damage.emit()
