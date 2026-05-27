extends Head

## Голова: Мозгоед

func _ready() -> void:
	super()


func update_desc():
	if invert_logic:
		description = tr("HD_SQUID_DESC_ELITE")
	else:
		match level:
			0:
				description = tr("HD_SQUID_DESC")
			1:
				description = tr("HD_SQUID_DESC2")
			2:
				description = tr("HD_SQUID_DESC3")


func apply_passive_effect():
	if invert_logic:
		DominoManager.head_draw_counter -= 1
		DominoManager.head_draw_counter_dec += 1
	else:
		DominoManager.head_draw_counter += 1
		match level:
			1:
				DominoManager.head_discard_draw_counter += 1
			2:
				DominoManager.head_discard_draw_counter += 1


func remove_passive_effect():
	if invert_logic:
		DominoManager.head_draw_counter += 1
		DominoManager.head_draw_counter_dec -= 1
	else:
		DominoManager.head_draw_counter -= 1
		match level:
			1:
				DominoManager.head_discard_draw_counter -= 1
			2:
				DominoManager.head_discard_draw_counter -= 1
