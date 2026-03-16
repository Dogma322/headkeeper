extends BoardBonus


func add_action():
	ActionManager.add(DecreaseMaxHpAction.new(self, Global.hero, 5))
	
func update_labels():
	name_label.text = tr("bn_enm_decrease_max_hp_name")
	des_label.text = TextFormatter.highlight_keywords(tr("bn_enm_decrease_max_hp_des") % 5)
