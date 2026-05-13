extends Area2D
class_name MapNode

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var done_sprite_2d: Sprite2D = $DoneSprite2D

var next: Array[MapNode] = []
var to_erase := false
var coord: Vector2i

var done: bool = false:
	set(value):
		done = value
		done_sprite_2d.visible = value
		done_sprite_2d.modulate.a = 0.0
		create_tween().tween_property(done_sprite_2d, "modulate:a", 1.0, 0.5)
		
var shadowed: bool = false:
	set(value):
		shadowed = value
		if value:
			sprite_2d.modulate = Color.DIM_GRAY
		else:
			sprite_2d.modulate = Color.WHITE

var stage: int:
	get:
		return coord.y

enum Type {
	UNKNOWN = -1,
	BATTLE,
	BATTLE_ELITE,
	SHOP,
	BONUS,
	CAMPFIRE,
	MAX
}

var type := Type.UNKNOWN:
	set(value):
		type = value
		match value:
			Type.BATTLE:
				sprite_2d.texture = preload("uid://dmowypaa6fxwu")
			Type.BATTLE_ELITE:
				sprite_2d.texture = preload("uid://bi1mc3tkrqcsl")
			Type.SHOP:
				sprite_2d.texture = preload("uid://cvyl8tia7gs6r")
			Type.BONUS:
				sprite_2d.texture = preload("uid://dgwgr870uqs6u")
			Type.CAMPFIRE:
				sprite_2d.texture = preload("uid://3q65om0qmd3q")
			pass
var string_hint: String = ""
var number_hint: int = 0

signal pressed


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			pressed.emit()
