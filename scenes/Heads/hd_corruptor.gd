extends Head

func _ready() -> void:
	hd_name = tr("hd_corruptor_name")
	description = tr("hd_corruptor_des")
	
	super()
	
func apply_passive_effect():
	DominoManager.corruption_bonus += 2
	
func remove_passive_effect():
	DominoManager.corruption_bonus += 2
