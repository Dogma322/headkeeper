extends ActionCard

func _ready() -> void:
	description = tr("end_run") 
	bonus_card = true
	super()
	
func effect():
	CombatManager.return_to_meta()
