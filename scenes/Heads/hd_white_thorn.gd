extends Head

func _ready() -> void:
	super()


func apply_passive_effect():
	BoardManager.bonus_pool.append(BoardManager.h_thorns)
	
func remove_passive_effect():
	BoardManager.bonus_pool.erase(BoardManager.h_thorns)
