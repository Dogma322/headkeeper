extends BoardBonus


func add_action():
	ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.draw, 1))
	
func update_labels():
	tooltip_panel.caption = tr("bn_draw_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("draw_1_des"))
