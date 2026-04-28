extends ActionCard

func _ready() -> void:
	description = tr("heal_bb_card_des") 
	super()
	
func effect():
	BoardManager.bonus_pool.append(BonusManager.bonus_effects.h_3heal)
