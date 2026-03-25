extends BoardBonus


func add_action():
	ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.repeat, 1))
	DominoManager.double_next_dm += 1
	
func update_labels():
	tooltip_panel.caption = tr("bn_repeat_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("dm_repeat_des"))
