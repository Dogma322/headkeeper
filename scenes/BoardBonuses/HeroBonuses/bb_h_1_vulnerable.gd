extends BoardBonus

## Бонус Уязвимости(1).

func add_action() -> void:
	for i in range(1 + Global.hero.repeat_positive_bonus_counter):
		ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.vulnerable, 1))


func update_labels() -> void:
	tooltip_panel.caption = tr("BN_VULNERABLE_NAME")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("BN_VULNERABLE_DESC") % 1)


func bonus_played() -> void:
	super()
	Global.hero.repeat_positive_bonus_counter = 0
