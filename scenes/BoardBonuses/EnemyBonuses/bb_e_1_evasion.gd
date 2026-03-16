extends BoardBonus


func add_action():
	ActionManager.add(BuffAction.new(self, Global.enemy, StatusManager.evasion, 1))
	
func update_labels():
	name_label.text = tr("bn_enm_evasion_name")
	des_label.text = TextFormatter.highlight_keywords(tr("bn_enm_evasion_des") % 1)
