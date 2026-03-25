extends BoardBonus


func add_action():
	ActionManager.add(NothingAction.new(self, Global.hero, 0))
	Global.enemy.block = 0
	
func update_labels():
	tooltip_panel.caption = tr("bn_remove_enemy_armor_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("bn_remove_enemy_armor_des"))
