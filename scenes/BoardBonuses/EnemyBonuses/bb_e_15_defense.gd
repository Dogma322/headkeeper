extends BoardBonus


func add_action() -> void:
	ActionManager.add(BlockAction.new(self, Global.enemy, 15))


func update_labels() -> void:
	tooltip_panel.caption = tr("bn_enm_defense_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("bn_enm_defense_des") % 15)
