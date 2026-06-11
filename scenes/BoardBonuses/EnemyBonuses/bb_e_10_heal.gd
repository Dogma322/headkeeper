@tool
extends BoardBonus

## Бонус: Проклятие Лечения(10).

func add_action():
	ActionManager.add(HealAction.new(self, Global.enemy, 10))
	
func update_labels():
	tooltip_panel.caption = tr("BN_ENM_HEAL_NAME")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("BN_ENM_HEAL_DESC") % 10)
