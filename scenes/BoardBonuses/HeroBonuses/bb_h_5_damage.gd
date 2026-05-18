extends BoardBonus


func add_action() -> void:
	for i in range(1 + Global.hero.repeat_positive_bonus_counter):
		ActionManager.add(AttackAction.new(self, Global.enemy, 5))


func update_labels() -> void:
	tooltip_panel.caption = tr("bn_attack_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("attack_des") % 5)


func bonus_played() -> void:
	super()
	Global.hero.repeat_positive_bonus_counter = 0
