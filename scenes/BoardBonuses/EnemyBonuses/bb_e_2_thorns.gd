extends BoardBonus

## Бонус: Проклятие Шипов(2).

func add_action() -> void:
	ActionManager.add(BuffAction.new(self, Global.enemy, StatusManager.thorns, 2))


func update_labels() -> void:
	tooltip_panel.caption = tr("BN_ENM_THORNS_NAME")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("BN_ENM_THORNS_DESC") % 2)
