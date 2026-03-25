extends BoardBonus


func add_action():
	ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.vulnerable, 1))
	
func update_labels():
	tooltip_panel.caption = tr("bn_vulnerable_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("vulnerable_des") % 1)
