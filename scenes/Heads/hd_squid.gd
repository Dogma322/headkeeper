extends Head

func _ready() -> void:
	super()
	
func apply_passive_effect():
	DominoManager.bonus_draw_counter += 1
	
func remove_passive_effect():
	DominoManager.bonus_draw_counter -= 1
