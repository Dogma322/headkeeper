extends BoardBonus


func add_action():
	ActionManager.add(HealAction.new(self, Global.enemy, 5))
	
func update_labels():
	name_label.text = tr("bn_enm_heal_name")
	des_label.text = TextFormatter.highlight_keywords(tr("bn_enm_heal_des") % 5)
