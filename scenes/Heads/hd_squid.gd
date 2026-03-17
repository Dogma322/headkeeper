extends Head

func _ready() -> void:
	hd_name = tr("hd_squid_name")
	description = tr("hd_squid_des")
	
	super()
	
func apply_passive_effect():
	DominoManager.bonus_draw_counter += 1
	
func remove_passive_effect():
	DominoManager.bonus_draw_counter -= 1
