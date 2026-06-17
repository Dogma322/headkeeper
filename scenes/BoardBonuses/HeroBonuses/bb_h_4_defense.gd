@tool
extends BoardBonus

## Бонус Защиты(4).

func add_action() -> void:
	ActionManager.add(BlockAction.new(self, Global.hero, 4))


func update_labels() -> void:
	tooltip_panel.caption = tr("BN_DEFENSE_NAME")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("BN_DEFENSE_DESC") % 4)
