@tool
extends BoardBonus

## Бонус: Проклятие Брони(5).

func add_action() -> void:
	ActionManager.add(BlockAction.new(self, Global.enemy, 5))


func update_labels() -> void:
	tooltip_panel.caption = tr("BN_ENM_DEFENSE_NAME")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("BN_ENM_DEFENSE_DESC") % 5)
