extends StatusResource

func initialize_status():
	status_changed.connect(_on_status_changed)
	_on_status_changed()

func _on_status_changed():
	owner.incoming_damage_mult = 1.5
