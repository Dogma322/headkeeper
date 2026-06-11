@tool
extends BoardBonus

## Бонус: Проклятие Лечения(5).

func add_action() -> void:
	ActionManager.add(HealAction.new(self, Global.enemy, 5))


func update_labels() -> void:
	tooltip_panel.caption = tr("BN_ENM_HEAL_NAME")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("BN_ENM_HEAL_DESC") % 5)
