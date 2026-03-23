extends Head

func _ready() -> void:
	super()
	
func apply_passive_effect():
	BoardManager.bonus_pool.append(BoardManager.h_1fury)
	BoardManager.bonus_pool.append(BoardManager.h_1fury)
	
func remove_passive_effect():
	BoardManager.bonus_pool.erase(BoardManager.h_1fury)
	BoardManager.bonus_pool.erase(BoardManager.h_1fury)
