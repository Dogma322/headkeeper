extends HBoxContainer

enum Type {
	BONUS,
	CAMPFIRE,
}

@export var type: Type = Type.BONUS

func _ready() -> void:
	if type == Type.BONUS:
		Global.action_card_container = self
	elif type == Type.CAMPFIRE:
		Global.campfire_card_container = self

func show_cont():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", Vector2(0,90), 0.5)
	tween.tween_property(self, "global_position", Vector2(0,60), 0.2)

func hide_cont():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", self.global_position + Vector2(0,30), 0.2)
	tween.tween_property(self, "global_position", self.global_position + Vector2(0,-300), 0.5)
	
func clear_cont():
	for child in get_children():
		child.queue_free()
