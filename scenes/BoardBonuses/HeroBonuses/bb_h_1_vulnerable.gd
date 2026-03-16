extends BoardBonus


func add_action():
	ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.vulnerable, 1))
	
func update_labels():
	name_label.text = tr("bn_vulnerable_name")
	des_label.text = TextFormatter.highlight_keywords(tr("vulnerable_des") % 1)
