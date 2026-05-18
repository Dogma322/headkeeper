extends BoardBonus


func add_action() -> void:
	for i in range(1 + Global.hero.repeat_positive_bonus_counter):
		ActionManager.add(BlockAction.new(self, Global.hero, 4))


func update_labels() -> void:
	tooltip_panel.caption = tr("bn_defense_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("defense_des") % 4)


func bonus_played() -> void:
	super()
	Global.hero.repeat_positive_bonus_counter = 0
