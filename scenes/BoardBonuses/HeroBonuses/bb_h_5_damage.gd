extends BoardBonus


func add_action():
	ActionManager.add(AttackAction.new(self, Global.enemy, 5))
	
func update_labels():
	tooltip_panel.caption = tr("bn_attack_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("attack_des") % 5)
