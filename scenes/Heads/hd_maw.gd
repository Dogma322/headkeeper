extends Head

func _ready() -> void:
	hd_name = tr("hd_maw_name")
	description = tr("hd_maw_des") % 35
	super()
	
func apply_passive_effect():
	ActionManager.add(DecreaseMaxHpAction.new(self, Global.hero, 35))
	ActionManager.play_one_action()
	
	BoardManager.bonus_pool.append(BoardManager.h_1crit)
	BoardManager.bonus_pool.append(BoardManager.h_1crit)
	
	
func remove_passive_effect():
	BoardManager.bonus_pool.erase(BoardManager.h_1crit)
	BoardManager.bonus_pool.erase(BoardManager.h_1crit)
