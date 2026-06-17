@tool
extends BoardBonus

## Бонус Лечения(3).

func add_action():
	ActionManager.add(HealAction.new(self, Global.hero, 3))


func update_labels():
	tooltip_panel.caption = tr("BN_HEAL_NAME")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("BN_HEAL_DESC") % 3)
