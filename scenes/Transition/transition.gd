extends CanvasLayer

@onready var blackout = $Blackout

func blackout_on_fast():
	blackout.modulate.a = 1

func blackout_off_fast():
	blackout.modulate.a = 0

func blackout_on():
	var tween = get_tree().create_tween()
	tween.tween_property(blackout, "modulate:a", 1, 0.6)
	
func blackout_off():
	var tween = get_tree().create_tween()
	tween.tween_property(blackout, "modulate:a", 0, 0.6)
