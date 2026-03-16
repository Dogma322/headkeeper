extends Action
class_name NothingAction

var damage:int

func _init(_source,_target,_damage):
	source = _source
	target = _target
	damage = _damage

func execute():
	pass
