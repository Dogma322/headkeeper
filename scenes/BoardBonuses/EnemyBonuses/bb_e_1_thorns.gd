extends BoardBonus


func add_action():
	ActionManager.add(BuffAction.new(self, Global.enemy, StatusManager.thorns, 1))
	
func update_labels():
	tooltip_panel.caption = tr("bn_enm_thorns_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("bn_enm_thorns_des") % 1)
