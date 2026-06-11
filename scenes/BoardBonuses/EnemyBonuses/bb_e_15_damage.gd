@tool
extends BoardBonus

## Бонус: Проклятие Атаки(15).

func add_action() -> void:
	ActionManager.add(AttackAction.new(self, Global.hero, 15))


func update_labels() -> void:
	tooltip_panel.caption = tr("BN_ENM_ATTACK_NAME")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("BN_ENM_ATTACK_DESC") % 15)
