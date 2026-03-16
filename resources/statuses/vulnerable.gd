extends StatusResource


func initialize_status():
	status_changed.connect(_on_status_changed)
	_on_status_changed()

func _on_status_changed():
	owner.incoming_damage_mult = 1.5
	
func remove_status_effect():
	owner.incoming_damage_mult = 1
	
func update_text():
	name = tr("st_vulnerable_name")
	des = tr("st_vulnerable_in_game_des")
