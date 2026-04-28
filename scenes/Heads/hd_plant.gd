extends Head

func _ready() -> void:
	super()
	
func apply_passive_effect():
	Global.hero.max_health += 20
	ActionManager.add(HealAction.new(self, Global.hero, 20))
	ActionManager.play_one_action()
	
	
	BoardManager.bonus_pool.append(BonusManager.bonus_effects.h_3heal)
	BoardManager.bonus_pool.append(BonusManager.bonus_effects.h_3heal)
	
	
func remove_passive_effect():
	BoardManager.bonus_pool.erase(BonusManager.bonus_effects.h_3heal)
	BoardManager.bonus_pool.erase(BonusManager.bonus_effects.h_3heal)
