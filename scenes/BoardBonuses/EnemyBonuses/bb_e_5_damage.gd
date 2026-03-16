extends BoardBonus


func add_action():
	ActionManager.add(AttackAction.new(self, Global.hero, 5))
	
func update_labels():
	name_label.text = tr("bn_enm_attack_name")
	des_label.text = TextFormatter.highlight_keywords(tr("bn_enm_attack_des") % 5)
