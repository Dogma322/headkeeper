extends BoardBonus


func add_action():
	ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.fury, -10))
	
func update_labels(): 
	tooltip_panel.caption = tr("bn_remove_strength_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("bn_remove_strength_des") % abs(-10))
