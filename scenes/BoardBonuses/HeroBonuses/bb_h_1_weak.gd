extends BoardBonus


func add_action():
	ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.vulnerable, 1))
	
func update_labels():
	tooltip_panel.caption = tr("bn_weak_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("weak_des") % 1)
