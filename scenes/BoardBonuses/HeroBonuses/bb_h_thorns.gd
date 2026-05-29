extends BoardBonus


func add_action() -> void:
	for i in range(1 + Global.hero.repeat_positive_bonus_counter):
		ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.thorns, 3))


func update_labels() -> void:
	tooltip_panel.caption = tr("bn_thorns_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("thorns_des") % 3)


func bonus_played() -> void:
	super()
	Global.hero.repeat_positive_bonus_counter = 0
