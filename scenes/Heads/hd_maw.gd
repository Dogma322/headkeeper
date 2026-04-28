extends Head

func _ready() -> void:
	super()
	
func apply_passive_effect():
	ActionManager.add(DecreaseMaxHpAction.new(self, Global.hero, value))
	ActionManager.play_one_action()
	
	BoardManager.bonus_pool.append(BonusManager.bonus_effects.h_1crit)
	BoardManager.bonus_pool.append(BonusManager.bonus_effects.h_1crit)
	
	
func remove_passive_effect():
	BoardManager.bonus_pool.erase(BonusManager.bonus_effects.h_1crit)
	BoardManager.bonus_pool.erase(BonusManager.bonus_effects.h_1crit)
