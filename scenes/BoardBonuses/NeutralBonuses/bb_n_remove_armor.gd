extends BoardBonus


func add_action():
	ActionManager.add(NothingAction.new(self, Global.hero, 0))
	Global.enemy.block = 0
	
func update_labels():
	name_label.text = tr("bn_remove_enemy_armor_name")
	des_label.text = TextFormatter.highlight_keywords(tr("bn_remove_enemy_armor_des"))
