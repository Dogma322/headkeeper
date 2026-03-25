extends BoardBonus


func add_action():
	ActionManager.add(BlockAction.new(self, Global.hero, 4))
	
func update_labels():
	tooltip_panel.caption = tr("bn_defense_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("defense_des") % 4)
