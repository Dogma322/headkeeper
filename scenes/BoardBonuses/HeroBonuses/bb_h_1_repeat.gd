extends BoardBonus


func add_action() -> void:
	for i in range(1 + Global.hero.repeat_positive_bonus_counter):
		ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.repeat, 1))
		DominoManager.double_next_dm += 1


func update_labels() -> void:
	tooltip_panel.caption = tr("bn_repeat_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("dm_repeat_des"))


func bonus_played() -> void:
	super()
	Global.hero.repeat_positive_bonus_counter = 0
