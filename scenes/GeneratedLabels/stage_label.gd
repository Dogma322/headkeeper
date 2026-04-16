extends Label


func _ready() -> void:
	update_text()
	Signals.stage_changed.connect(update_text)

func update_text():
	var stage = 0
	if CombatManager.map_node != null:
		stage = CombatManager.map_node.stage
	else:
		stage = CombatManager.stage
	
	if CombatManager.stage <= 10:
		text = tr("stage") % stage + "/10"
	else:
		text = tr("stage") % stage
