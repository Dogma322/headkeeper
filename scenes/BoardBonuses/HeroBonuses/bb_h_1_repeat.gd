@tool
extends BoardBonus

## Бонус Повтора(1).

func add_action() -> void:
	for i in range(1 + Global.hero.repeat_positive_bonus_counter):
		ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.repeat, 1))
		DominoManager.double_next_dm += 1


func update_labels() -> void:
	tooltip_panel.caption = tr("BN_REPEAT_NAME")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("BN_REPEAT_DESC"))
