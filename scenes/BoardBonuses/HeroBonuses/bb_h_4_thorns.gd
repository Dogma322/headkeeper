@tool
extends BoardBonus

## Бонус Шипов(4).

func add_action() -> void:
	for i in range(1 + Global.hero.repeat_positive_bonus_counter):
		ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.thorns, 4))


func update_labels() -> void:
	tooltip_panel.caption = tr("BN_THORNS_NAME")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("BN_THORNS_DESC") % 4)
