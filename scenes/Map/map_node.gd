extends Area2D
class_name MapNode

var links: Array[MapNode] = []
var next: Array[MapNode] = []
var prev: Array[MapNode] = []
var to_erase: bool = false
var coord: Vector2i


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			pass
