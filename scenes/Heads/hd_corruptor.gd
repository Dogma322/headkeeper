extends Head

func _ready() -> void:
	super()
	
func apply_passive_effect():
	DominoManager.corruption_bonus += 2
	
func remove_passive_effect():
	DominoManager.corruption_bonus += 2
