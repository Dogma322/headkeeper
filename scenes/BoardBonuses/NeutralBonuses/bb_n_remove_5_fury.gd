@tool
extends BoardBonus

func add_action() -> void:
	ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.fury, -5))
	
func update_labels() -> void: 
	tooltip_panel.caption = tr("BN_NTR_REMOVE_FURY_NAME")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("BN_NTR_REMOVE_FURY_DESC") % abs(-5))
