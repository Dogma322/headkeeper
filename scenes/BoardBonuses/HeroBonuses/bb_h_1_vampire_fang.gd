@tool
extends BoardBonus

## Бонус Вампирский Клык(1).

func add_action() -> void:
	ActionManager.add(AttackAction.new(self, Global.enemy, 6))
	ActionManager.add(HealAction.new(self, Global.hero, 3))


func update_labels() -> void:
	tooltip_panel.caption = tr("BN_VAMPIRE_FANG_NAME")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("BN_VAMPIRE_FANG_DESC"))
