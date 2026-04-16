extends Area2D
class_name MapNode

var next: Array[MapNode] = []
var to_erase: bool = false
var coord: Vector2i

var stage: int:
	get:
		return coord.y

enum Type {
	UNKNOWN = -1,
	BATTLE,
	MAX
}

var type = Type.UNKNOWN
var string_hint: String = ""
var number_hint: int = 0

signal pressed

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			pressed.emit()
