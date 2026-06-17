@tool
extends BoardBonus

## Бонус Слабости(1).

func add_action() -> void:
	ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.vulnerable, 1))


func update_labels() -> void:
	tooltip_panel.caption = tr("BN_WEAK_NAME")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("BN_WEAK_DESC") % 1)
