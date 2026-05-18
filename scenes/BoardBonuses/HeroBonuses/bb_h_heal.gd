extends BoardBonus


func add_action():
	for i in range(1 + Global.hero.repeat_positive_bonus_counter):
		ActionManager.add(HealAction.new(self, Global.hero, 3))


func update_labels():
	tooltip_panel.caption = tr("bn_enm_heal_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("bn_enm_heal_des") % 3)


func bonus_played() -> void:
	super()
	Global.hero.repeat_positive_bonus_counter = 0
