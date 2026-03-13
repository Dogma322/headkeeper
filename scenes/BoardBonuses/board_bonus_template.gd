extends TextureRect
class_name BoardBonus

var slot_owner

@onready var aim_marker = $Marker2D

func play_anim():
	z_index = 999
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(self, "scale", Vector2(4,4), 0.5)
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	
func add_action():
	ActionManager.add(AttackAction.new(self, Global.enemy, 5))
