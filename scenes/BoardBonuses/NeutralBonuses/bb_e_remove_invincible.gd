extends BoardBonus


func add_action():
	ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.invincible, -1))
	
func update_labels():
	tooltip_panel.caption = tr("bn_remove_invincible_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("bn_remove_invincible_des"))
