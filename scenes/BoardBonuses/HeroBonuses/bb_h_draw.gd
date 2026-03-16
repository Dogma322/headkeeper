extends BoardBonus


func add_action():
	ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.draw, 1))
	
func update_labels():
	name_label.text = tr("bn_draw_name")
	des_label.text = TextFormatter.highlight_keywords(tr("draw_1_des"))
