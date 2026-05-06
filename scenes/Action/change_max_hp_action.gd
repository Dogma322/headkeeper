class_name ChangeMaxHpAction
extends Action

var value: int


func _init(_source, _target, _value: int) -> void:
	source = _source
	target = _target
	value = _value


func execute() -> void:
	target.max_health -= value
	if target.health > target.max_health:
		target.health = target.max_health
	elif value < 0:
		target.health += -value
	AnimationManager.spawn_anim(AnimationManager.heal_anim if value < 0 else AnimationManager.debuff_anim, target, 0)
	Signals.hero_health_changed.emit()
