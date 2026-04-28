extends CanvasLayer

@onready var blackout_surface = $Blackout

func blackout_on_fast():
	blackout_surface.modulate.a = 1

func blackout_off_fast():
	blackout_surface.modulate.a = 0

func blackout() -> void:
	blackout_on()
	await get_tree().create_timer(1.0).timeout
	blackout_off()

func blackout_on():
	var tween = get_tree().create_tween()
	tween.tween_property(blackout_surface, "modulate:a", 1, 0.6)
	IconButton.activate_all_buttons(false)
	GameButton.activate_all_buttons(false)
	
func blackout_off():
	var tween = get_tree().create_tween()
	tween.tween_property(blackout_surface, "modulate:a", 0, 0.6)
	IconButton.activate_all_buttons(true)
	GameButton.activate_all_buttons(true)
