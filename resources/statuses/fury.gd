extends StatusResource


func initialize_status():
	status_changed.connect(_on_status_changed)
	_on_status_changed()

func _on_status_changed():
	owner.bonus_damage = stacks

func remove_status_effect():
	owner.bonus_damage = 0

func update_text():
	name = tr("st_strength_name")
	if stacks > 0:
		des = tr("st_strength_in_game_des") % stacks
	else:
		des = tr("st_negative_strength_in_game_des") % abs(stacks)
