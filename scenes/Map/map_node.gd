extends Area2D
class_name MapNode

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var done_sprite_2d: Sprite2D = $DoneSprite2D

var next: Array[MapNode] = []
var to_erase := false
var coord: Vector2i
var generated := false

var done: bool = false:
	set(value):
		done = value
		done_sprite_2d.visible = value
		done_sprite_2d.modulate.a = 0.0
		create_tween().tween_property(done_sprite_2d, "modulate:a", 1.0, 0.5)
		
var shadowed: bool = true:
	set(value):
		shadowed = value
		if value:
			sprite_2d.modulate = Color.DIM_GRAY
		else:
			sprite_2d.modulate = Color.WHITE

var stage: int:
	get:
		return coord.y

var is_final := false

enum Type {
	UNKNOWN = -1,
	BATTLE,
	BATTLE_ELITE,
	SHOP,
	HEADS,
	POND,
	EVENT,
	MAX
}

var type := Type.UNKNOWN:
	set(value):
		type = value
		match value:
			Type.UNKNOWN:
				sprite_2d.texture = preload("res://assets/Icons/MapIcons/point_map_icon.atlastex")
			Type.BATTLE:
				sprite_2d.texture = preload("res://assets/Icons/MapIcons/battle_map_icon.atlastex")
			Type.BATTLE_ELITE:
				sprite_2d.texture = preload("res://assets/Icons/MapIcons/battle_elite_map_icon.atlastex")
			Type.SHOP:
				sprite_2d.texture = preload("res://assets/Icons/MapIcons/shop_map_icon.atlastex")
			Type.HEADS:
				sprite_2d.texture = preload("res://assets/Icons/MapIcons/bonus_map_icon.atlastex")
			Type.POND:
				sprite_2d.texture = preload("res://assets/Icons/MapIcons/campfire_map_icon.atlastex")
			Type.EVENT:
				sprite_2d.texture = preload("res://assets/Icons/MapIcons/unknown_map_icon.atlastex")
			pass

var string_hint: String = ""
var number_hint: int = 0

signal pressed


func _ready() -> void:
	sprite_2d.modulate = Color.DIM_GRAY
	match type:
		Type.UNKNOWN:
			sprite_2d.texture = preload("res://assets/Icons/MapIcons/point_map_icon.atlastex")
		Type.BATTLE:
			sprite_2d.texture = preload("res://assets/Icons/MapIcons/battle_map_icon.atlastex")
		Type.BATTLE_ELITE:
			sprite_2d.texture = preload("res://assets/Icons/MapIcons/battle_elite_map_icon.atlastex")
		Type.SHOP:
			sprite_2d.texture = preload("res://assets/Icons/MapIcons/shop_map_icon.atlastex")
		Type.HEADS:
			sprite_2d.texture = preload("res://assets/Icons/MapIcons/bonus_map_icon.atlastex")
		Type.POND:
			sprite_2d.texture = preload("res://assets/Icons/MapIcons/campfire_map_icon.atlastex")
		Type.EVENT:
			sprite_2d.texture = preload("res://assets/Icons/MapIcons/unknown_map_icon.atlastex")


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			pressed.emit()
