@tool
extends BoardBonus

## Бонус: Проклятие Уклонения(1).

func add_action() -> void:
	ActionManager.add(BuffAction.new(self, Global.enemy, StatusManager.evasion, 1))


func update_labels() -> void:
	tooltip_panel.caption = tr("BN_ENM_EVASION_NAME")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("BN_ENM_EVASION_DESC") % 1)
