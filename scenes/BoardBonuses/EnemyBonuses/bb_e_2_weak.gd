extends BoardBonus

## Бонус: Проклятие Слабости(2).

func add_action() -> void:
	ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.weak, 2))


func update_labels() -> void:
	tooltip_panel.caption = tr("BN_ENM_WEAK_NAME")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("BN_ENM_WEAK_DESC") % 2)
