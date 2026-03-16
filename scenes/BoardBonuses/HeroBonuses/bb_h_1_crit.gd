extends BoardBonus


func add_action():
	ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.crit, 1))
	
func update_labels():
	name_label.text = tr("bn_crit_name")
	des_label.text = TextFormatter.highlight_keywords(tr("dm_crit_des"))
