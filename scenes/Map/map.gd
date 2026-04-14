extends Control
class_name Map

@export var grid_width := 7
@export var grid_height := 15

@export var grid_node_scene: PackedScene
@onready var start: Marker2D = $Start


var floors = []
var links = []
var current_paths = {}

class MapPath:
	var nodes
	var color: Color

	func _init(_nodes, _color):
		nodes = _nodes
		color = _color

func _ready() -> void:
	generate()

func add_to_path_rec(node: MapNode, paths):
	if node.next.is_empty():
		return
	
	var arr = node.next.duplicate()
	arr.shuffle()
	
	for n in node.prev:
		if n != arr[0]:
			n.next.erase(node)
			node.prev.erase(n) 
	
	for path in paths:
		if arr[0] in path:
			return
	
	add_to_path_rec(arr[0], paths)

func generate() -> void:
	
	#region Сгенерируем граф.
	
	for y in range(grid_height):
		var arr: Array[MapNode] = []
		for x in range(grid_width):
			var node = add_node(Vector2i(x, y))
			if y > 0:
				if x - 1 >= 0:
					floors[y - 1][x - 1].next.push_back(node)
					node.prev.push_back(floors[y - 1][x - 1])
				floors[y - 1][x].next.push_back(node)
				node.prev.push_back(floors[y - 1][x])
				if x + 1 < grid_width:
					floors[y - 1][x + 1].next.push_back(node)
					node.prev.push_back(floors[y - 1][x + 1])
			arr.push_back(node)
		floors.push_back(arr)
	
	#endregion
	
	#region Случайно выберем и удалим точки.
	
	for y in range(1):
		var floor_nodes = []
		while floor_nodes.size() < 2:
			floor_nodes = floors[y].filter(func(_node): return randi_range(0, 1))
		var x = 0
		for node: MapNode in floors[y]:
			if node not in floor_nodes:
				node.erased = true
			else:
				var random_color = Color(randf(), randf(), randf())
				if Vector3(random_color.r, random_color.g, random_color.b).length() < 0.5:
					random_color = random_color.lightened(0.25)
				current_paths[x] = MapPath.new([node], random_color)
			x += 1
	
	for y in range(grid_height):
		for x in range(grid_width):
			if current_paths.has(x):
				var path = current_paths[x]
				var arr = []
				
				for next in path.nodes[-1].next:
					arr.push_back(next)
				arr.shuffle()
					
				for other_path in current_paths.values():
					if other_path == path:
						continue
					if arr.is_empty():
						break
					if y < other_path.nodes.size():
						for node in other_path.nodes[y].next:
							if node == arr[0]:
								arr[0].erased = true
								arr.erase(arr[0])
								break
				
				if not arr.is_empty():
					if arr.size() > 1:
						arr.shuffle()
					path.nodes.push_back(arr[0])
				
	
	#endregion
	
	## Создадим пути.
	#for x in range(grid_width):
		#var path = []
		#add_to_path_rec(floors[x][0], current_paths)
		#current_paths.push_back(path)
	#
	#
	## Удалим ненужные ноды.
	for arr in floors:
		for node in arr:
			var found = false
			for path in current_paths.values():
				if path.nodes.has(node):
					found = true
					break
			if not found:
				node.erased = true
	
	for arr in floors:
		for node in arr:
			if node.erased:
				for prev in node.prev:
					prev.next.erase(node)
				arr.erase(node)
				node.queue_free()
	
	#region Создадим ноду с боссом.
	
	
	var boss_node = add_node(Vector2i(3, (grid_height + 1)))
	for path: MapPath in current_paths.values():
		path.nodes.push_back(boss_node)
		path.nodes[-1].next.push_back(boss_node)
		boss_node.prev.push_back(path.nodes[-1])
	floors.push_back([boss_node])
	
	#endregion
	
	queue_redraw()

func add_node(coord: Vector2i) -> MapNode:
	var offset := get_viewport_rect().size.x / 10.0
	var pos = Vector2(coord.x * 20 - offset, coord.y * 20)
	
	var instance: MapNode = grid_node_scene.instantiate()
	start.add_child(instance)
	pos.y = -pos.y
	instance.coord = coord
	instance.position = pos
	return instance

func add_link(from: MapNode, to: MapNode):
	pass

func draw_links():
	for key in current_paths.keys():
		var path = current_paths[key]
		var i = 0
		for node in path.nodes:
			if i > 0:
				draw_line(path.nodes[i - 1].global_position, node.global_position, path.color)
			i += 1
	
	#for arr in floors:
		#for node: MapNode in arr:
			#for next in node.next:
				#draw_line(node.global_position, next.global_position, Color.WHITE)

func _draw() -> void:
	draw_links()
