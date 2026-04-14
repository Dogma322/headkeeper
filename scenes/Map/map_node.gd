extends Node2D
class_name MapNode

var links: Array[MapNode] = []
var next: Array[MapNode] = []
var prev: Array[MapNode] = []
var erased: bool = false
var coord: Vector2i

func erase_prev(node):
	if prev.has(node):
		prev.erase(node)
		node.next.erase(self)
		
