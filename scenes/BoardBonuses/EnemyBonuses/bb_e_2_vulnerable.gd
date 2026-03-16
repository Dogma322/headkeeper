extends BoardBonus


func add_action():
	ActionManager.add(DebuffAction.new(self, Global.hero, StatusManager.vulnerable, 2))
	
func update_labels():
	name_label.text = tr("bn_enm_vulnerable_name")
	des_label.text = TextFormatter.highlight_keywords(tr("vulnerable_des") % 2)
