extends Resource
class_name LevelSettings

@export var probability_battle_weight: float = 8.0
@export var probability_battle_elite_weight: float = 3.0
@export var probability_shop_weight: float = 1.0
@export var probability_bonus_weight: float = 3.0
@export var probability_campfire_weight: float = 2.0

func probability_sum() -> float:
	return probability_battle_weight + probability_battle_elite_weight + probability_shop_weight + probability_bonus_weight + probability_campfire_weight
