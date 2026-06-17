@tool
extends BoardBonus

## Бонус Атаки(5).

func add_action() -> void:
	ActionManager.add(AttackAction.new(self, Global.enemy, 5))


func update_labels() -> void:
	tooltip_panel.caption = tr("BN_ATTACK_NAME")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("BN_ATTACK_DESC") % 5)
