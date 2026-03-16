extends BoardBonus


func add_action():
	ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.fury, -5))
	
func update_labels(): 
	name_label.text = tr("bn_remove_strength_name")
	des_label.text = TextFormatter.highlight_keywords(tr("bn_remove_strength_des") % abs(-5))
