extends BoardBonus

## Бонус Огненный Шар(1).

func add_action() -> void:
	for i in range(1 + Global.hero.repeat_positive_bonus_counter):
		ActionManager.add(AttackAction.new(self, Global.enemy, 15))


func update_labels() -> void:
	tooltip_panel.caption = tr("BN_FIREBALL_NAME")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("BN_FIREBALL_DESC"))


func bonus_played() -> void:
	super()
	Global.hero.repeat_positive_bonus_counter = 0
