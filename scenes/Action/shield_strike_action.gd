class_name ShieldStrikeAction
extends Action

var damage: int
var mult: int


func _init(_source, _target, _mult: int) -> void:
	source = _source
	target = _target
	mult = _mult


func execute() -> void:
	damage = Global.hero.block * mult
	var final_damage := damage
	
	if source is Domino:
		final_damage = ActionManager.final_calculate_damage(source, target, damage)
		
	target.take_damage(final_damage)
	AnimationManager.spawn_anim(AnimationManager.attack_anim, target, final_damage)
	Signals.play_damage_sound.emit()
	
	if source is Domino:
		Signals.deal_hero_thorn_damage.emit()
	if source is Enemy:
		Signals.deal_enemy_thorn_damage.emit()
