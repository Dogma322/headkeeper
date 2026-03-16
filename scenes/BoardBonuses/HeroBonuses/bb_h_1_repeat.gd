extends BoardBonus


func add_action():
	ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.repeat, 1))
	DominoManager.double_next_dm += 1
	
func update_labels():
	name_label.text = tr("bn_repeat_name")
	des_label.text = TextFormatter.highlight_keywords(tr("dm_repeat_des"))
