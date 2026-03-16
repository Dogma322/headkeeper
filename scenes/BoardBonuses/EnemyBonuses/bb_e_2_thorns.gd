extends BoardBonus


func add_action():
	ActionManager.add(BuffAction.new(self, Global.enemy, StatusManager.thorns, 2))
	
func update_labels():
	name_label.text = tr("bn_enm_thorns_name")
	des_label.text = TextFormatter.highlight_keywords(tr("bn_enm_thorns_des") % 2)
