@tool
extends BoardBonus

## Бонус: Проклятие Ярости(5).

func add_action() -> void:
	ActionManager.add(BuffAction.new(self, Global.enemy, StatusManager.fury, 5))


func update_labels() -> void:
	tooltip_panel.caption = tr("BN_ENM_FURY_NAME")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("BN_ENM_FURY_DESC") % 5)
