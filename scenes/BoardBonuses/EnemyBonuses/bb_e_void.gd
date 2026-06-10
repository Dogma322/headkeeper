extends BoardBonus


func add_action() -> void:
	ActionManager.add(AttackAction.new(self, Global.hero, 9999))


func update_labels() -> void:
	tooltip_panel.caption = tr("bn_enm_void_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("bn_enm_void_des"))
