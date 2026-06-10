extends BoardBonus


func add_action() -> void:
	ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.weak, 2))


func update_labels() -> void:
	tooltip_panel.caption = tr("bn_enm_weak_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("bn_enm_weak_des") % 2)
