extends Label


func _ready() -> void:
	update_text.call_deferred()
	Signals.stage_changed.connect(update_text)

func update_text():
	var stage = 0
	if CombatManager.map_node != null:
		stage = CombatManager.map_node.stage
	
	if stage <= 15:
		text = tr("stage") % stage + "/15"
	else:
		text = tr("stage") % stage
