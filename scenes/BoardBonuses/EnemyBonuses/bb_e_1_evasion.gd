extends BoardBonus


func add_action() -> void:
	ActionManager.add(BuffAction.new(self, Global.enemy, StatusManager.evasion, 1))


func update_labels() -> void:
	tooltip_panel.caption = tr("bn_enm_evasion_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("bn_enm_evasion_des") % 1)
