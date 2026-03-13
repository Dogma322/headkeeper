class_name Action
extends RefCounted

var source
var target


func _init(_source = null, _target = null):
	source = _source
	target = _target


func execute() -> void:
	# переопределяется в наследниках
	pass
