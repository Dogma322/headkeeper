extends BoardBonus


func add_action():
	ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.fury, 1))
	
func update_labels():
	tooltip_panel.caption = tr("bn_strength_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("strength_des") % 1)
