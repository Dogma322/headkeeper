@tool
extends BoardBonus

## Бонус: Проклятие Уязвимости(2).

func add_action() -> void:
	ActionManager.add(DebuffAction.new(self, Global.hero, StatusManager.vulnerable, 2))


func update_labels() -> void:
	tooltip_panel.caption = tr("BN_ENM_VULNERABLE_NAME")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("BN_ENM_VULNERABLE_DESC") % 2)
