extends ActionCard

func _ready() -> void:
	description = tr("crit_bb_card_des") 
	super()
	
func effect():
	BoardManager.bonus_pool.append(BonusManager.bonus_effects.h_1crit)
