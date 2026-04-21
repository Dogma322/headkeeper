extends ActionCard

func _ready() -> void:
	description = tr("heal_card_des") % 30
	super()
	
func effect():
	ActionManager.add(HealAction.new(self, Global.hero, 30))
	ActionManager.play_one_action()
	Signals.hero_health_changed.emit()
