extends Head

## Голова: Белый Шип

func _ready() -> void:
	super()


func update_desc() -> void:
	pass


func apply_passive_effect() -> void:
	BoardManager.bonus_pool.append(BoardManager.h_thorns)


func remove_passive_effect() -> void:
	BoardManager.bonus_pool.erase(BoardManager.h_thorns)
