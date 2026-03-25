extends BoardBonus


func add_action():
	ActionManager.add(HealAction.new(self, Global.enemy, 15))
	
func update_labels():
	tooltip_panel.caption = tr("bn_enm_heal_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("bn_enm_heal_des") % 15)
