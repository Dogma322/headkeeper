extends Head

func _ready() -> void:
	hd_name = tr("hd_thorn_name")
	description = tr("hd_thorn_des")
	
	super()
	
func apply_passive_effect():
	BoardManager.bonus_pool.append(BoardManager.h_thorns)
	
func remove_passive_effect():
	BoardManager.bonus_pool.erase(BoardManager.h_thorns)
