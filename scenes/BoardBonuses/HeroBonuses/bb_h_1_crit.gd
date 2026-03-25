extends BoardBonus


func add_action():
	ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.crit, 1))
	
func update_labels():
	tooltip_panel.caption = tr("bn_crit_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("dm_crit_des"))
