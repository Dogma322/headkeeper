extends StatusResource


func initialize_status():
	status_changed.connect(_on_status_changed)
	_on_status_changed()

func _on_status_changed():
	owner.damage_mult = 0.75
