extends ActionCard

func _ready() -> void:
	description = tr("inscrease_max_hp_card_des") % 10
	super()
	
func effect():
	Global.hero.max_health += 10
	ActionManager.add(HealAction.new(self, Global.hero, 10))
	ActionManager.play_one_action()
