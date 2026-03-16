extends StatusResource


func initialize_status():
	status_changed.connect(_on_status_changed)
	_on_status_changed()

func _on_status_changed():
	owner.damage_mult = 0.75

func remove_status_effect():
	owner.damage_mult = 1

func update_text():
	name = tr("st_weak_name")
	des = tr("st_weak_in_game_des")
