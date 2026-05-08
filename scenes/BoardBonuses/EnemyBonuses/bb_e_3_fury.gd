extends BoardBonus


func add_action() -> void:
	ActionManager.add(BuffAction.new(self, Global.enemy, StatusManager.fury, 3))


func update_labels() -> void:
	tooltip_panel.caption = tr("bn_enm_strength_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("bn_enm_strength_des") % 3)
