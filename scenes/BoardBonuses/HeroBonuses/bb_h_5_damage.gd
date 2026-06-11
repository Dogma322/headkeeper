extends BoardBonus

## Бонус Атаки(5).

func add_action() -> void:
	for i in range(1 + Global.hero.repeat_positive_bonus_counter):
		ActionManager.add(AttackAction.new(self, Global.enemy, 5))


func update_labels() -> void:
	tooltip_panel.caption = tr("BN_ATTACK_NAME")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("BN_ATTACK_DESC") % 5)


func bonus_played() -> void:
	super()
	Global.hero.repeat_positive_bonus_counter = 0
