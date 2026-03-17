extends Head

func _ready() -> void:
	hd_name = tr("hd_plant_name")
	description = tr("hd_plant_des") % [3, 20]
	
	super()
	
func apply_passive_effect():
	Global.hero.max_health += 20
	ActionManager.add(HealAction.new(self, Global.hero, 20))
	ActionManager.play_one_action()
	
	
	BoardManager.bonus_pool.append(BoardManager.h_3heal)
	BoardManager.bonus_pool.append(BoardManager.h_3heal)
	
	
func remove_passive_effect():
	BoardManager.bonus_pool.erase(BoardManager.h_3heal)
	BoardManager.bonus_pool.erase(BoardManager.h_3heal)
