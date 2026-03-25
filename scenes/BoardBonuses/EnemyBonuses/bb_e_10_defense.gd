extends BoardBonus


func add_action():
	ActionManager.add(BlockAction.new(self, Global.enemy, 10))
	
func update_labels():
	tooltip_panel.caption = tr("bn_enm_defense_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("bn_enm_defense_des") % 10)
