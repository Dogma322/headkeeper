extends Label


func _ready() -> void:
	update_text()
	Signals.stage_changed.connect(update_text)

func update_text():
	if CombatManager.stage <= 10:
		text = tr("stage") % CombatManager.stage + "/10"
	else:
		text = tr("stage") % CombatManager.stage
