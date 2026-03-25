extends BoardBonus


func add_action():
	ActionManager.add(DebuffAction.new(self, Global.hero, StatusManager.vulnerable, 2))
	
func update_labels():
	tooltip_panel.caption = tr("bn_enm_vulnerable_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("vulnerable_des") % 2)
