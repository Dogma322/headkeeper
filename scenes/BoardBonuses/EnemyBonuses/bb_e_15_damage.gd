extends BoardBonus


func add_action():
	ActionManager.add(AttackAction.new(self, Global.hero, 15))
	
func update_labels():
	tooltip_panel.caption = tr("bn_enm_attack_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("bn_enm_attack_des") % 15)
