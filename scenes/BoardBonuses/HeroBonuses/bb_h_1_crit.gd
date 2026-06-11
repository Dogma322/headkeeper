extends BoardBonus

## Бонус Крита(1).

func add_action() -> void:
	for i in range(1 + Global.hero.repeat_positive_bonus_counter):
		ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.crit, 1))


func update_labels() -> void:
	tooltip_panel.caption = tr("BN_CRIT_NAME")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("BN_CRIT_DESC"))


func bonus_played() -> void:
	super()
	Global.hero.repeat_positive_bonus_counter = 0
