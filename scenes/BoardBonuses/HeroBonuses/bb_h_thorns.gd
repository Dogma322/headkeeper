extends BoardBonus


func add_action():
	ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.thorns, 4))
	
func update_labels():
	name_label.text = tr("bn_thorns_name")
	des_label.text = TextFormatter.highlight_keywords(tr("thorns_des") % 4)
