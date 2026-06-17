@tool
extends BoardBonus

## Бонус Сброса(1).

func add_action() -> void:
	ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.draw, 1))


func update_labels() -> void:
	tooltip_panel.caption = tr("BN_DRAW_NAME")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("BN_DRAW_DESC"))
