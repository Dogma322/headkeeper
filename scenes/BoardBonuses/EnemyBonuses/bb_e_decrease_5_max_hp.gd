extends BoardBonus


func add_action() -> void:
	ActionManager.add(ChangeMaxHpAction.new(self, Global.hero, 5))


func update_labels() -> void:
	tooltip_panel.caption = tr("bn_enm_decrease_max_hp_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("bn_enm_decrease_max_hp_des") % 5)
