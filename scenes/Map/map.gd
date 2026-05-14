extends Control
class_name Map

@export var grid_width := 7
@export var grid_height := 15
@export var min_path_count := 4
@export var max_path_count := 4
@export var branch_count := 3

@export var level_settings: Array[LevelSettings]


@onready var start: Marker2D = $Start

signal node_mouse_entered(node: MapNode)
signal node_mouse_exited
signal node_pressed(node: MapNode)

var nodes = []
var floors = []
var current_paths = {}

@onready var temp_early_enemy_keys = EnemyManager.early_enemy_keys.duplicate()
@onready var temp_mid_enemy_keys = EnemyManager.mid_enemy_keys.duplicate()
@onready var temp_late_enemy_keys = EnemyManager.late_enemy_keys.duplicate()

var early_enemy_pool_keys = []
var mid_enemy_pool_keys = []
var late_enemy_pool_keys = []

@onready var grid_node_scene = preload("res://scenes/Map/map_node.tscn")
@onready var rng := RandomNumberGenerator.new()

class MapPath:
	var nodes
	var color: Color

	func _init(_nodes, _color):
		nodes = _nodes
		color = _color


func clear():
	for node in nodes:
		node.queue_free()
	nodes.clear()
	floors.clear()
	current_paths.clear()


func _ready() -> void:
	randomize()
	rng.randomize()

func reset_enemy_pools():
	temp_early_enemy_keys = EnemyManager.early_enemy_keys.duplicate()
	temp_mid_enemy_keys = EnemyManager.mid_enemy_keys.duplicate()
	temp_late_enemy_keys = EnemyManager.late_enemy_keys.duplicate()

	for element in temp_early_enemy_keys:
		early_enemy_pool_keys.push_back(element)
	early_enemy_pool_keys.shuffle()
	for element in temp_mid_enemy_keys:
		mid_enemy_pool_keys.push_back(element)
	mid_enemy_pool_keys.shuffle()
	for element in temp_late_enemy_keys:
		late_enemy_pool_keys.push_back(element)
	late_enemy_pool_keys.shuffle()

func generate() -> void:
	clear()
	reset_enemy_pools()
	
	#region Сгенерируем граф.
	
	for y in range(grid_height):
		var arr: Array[MapNode] = []
		for x in range(grid_width):
			var node = add_node(Vector2i(x, y))
			if y > 0:
				if x - 1 >= 0:
					floors[y - 1][x - 1].next.push_back(node)
				floors[y - 1][x].next.push_back(node)
				if x + 1 < grid_width:
					floors[y - 1][x + 1].next.push_back(node)
			else:
				node.shadowed = false
			arr.push_back(node)
		floors.push_back(arr)
	
	#endregion
	
	#region Создадим начальные точки путей.
	
	var floor_nodes = []
	var path_count = 0
	if min_path_count == max_path_count:
		path_count = min(max_path_count, grid_width)
	else:
		path_count = randi_range(min(min_path_count, grid_width), min(max_path_count, grid_width))
	while floor_nodes.size() != path_count:
		floor_nodes = floors[0].filter(func(_node): return randi_range(0, 1))
	var path_id = 0
	for node: MapNode in floors[0]:
		if node in floor_nodes:
			var random_color = Color(randf(), randf(), randf())
			if Vector3(random_color.r, random_color.g, random_color.b).length() < 0.5:
				random_color = random_color.lightened(0.25)
			current_paths[path_id] = MapPath.new([node], random_color)
		path_id += 1
		
	#endregion
	
	#region Пройдем по дереву и продолжим пути.
	
	for y in range(grid_height):
		for x in range(grid_width):
			if current_paths.has(x):
				var path = current_paths[x]
				var arr = []
				var current = path.nodes[-1]
				
				for next in current.next:
					arr.push_back(next)
				
				for other_path in current_paths.values():
					if other_path == path:
						continue
					if arr.is_empty():
						break
					if y < other_path.nodes.size():
						for element in arr:
							if other_path.nodes[y].coord.x == element.coord.x:
								current.next.erase(element)
								arr.erase(element)
				
				if not arr.is_empty():
					if arr.size() > 1:
						arr.shuffle()
					for node in arr:
						if node == arr[0]:
							continue
						current.next.erase(node)
					path.nodes.push_back(arr[0])
	
	#endregion
	
	#region Пометим для удаления не входящие в пути ноды.
	
	for arr in floors:
		for node in arr:
			var found = false
			for path in current_paths.values():
				if path.nodes.has(node):
					found = true
					break
			if not found:
				node.to_erase = true
	
	#endregion
	
	#region Создадим ноду с боссом.
	
	var boss_node = add_node(Vector2i(3, grid_height))
	for path: MapPath in current_paths.values():
		path.nodes[-1].next.push_back(boss_node)
		path.nodes.push_back(boss_node)
	floors.push_back([boss_node])
	
	#endregion
	
	#region Удалим лишние ноды.
	
	for arr: Array in floors:
		for node in arr:
			if node.to_erase:
				node.queue_free()
				nodes.erase(node)
	
	#endregion
	
	queue_redraw()


func add_node(coord: Vector2i) -> MapNode:
	var offset2 := get_viewport_rect().size.x / 10.0
	var pos = Vector2(coord.x * 20 - offset2, -coord.y * 20)
	
	var instance: MapNode = grid_node_scene.instantiate()
	start.add_child(instance)
	
	var progress = coord.y
	
	# --------------
	# MapNode.Type
	# --------------
	# BATTLE,
	# BATTLE_ELITE
	# SHOP,
	# BONUS,
	# CAMPFIRE
	# --------------
	
	var arr = [MapNode.Type.BATTLE, MapNode.Type.BATTLE_ELITE, MapNode.Type.SHOP, MapNode.Type.BONUS, MapNode.Type.CAMPFIRE]
	var sum = level_settings[progress].probability_sum()
	var arr_index = rng.rand_weighted([level_settings[progress].probability_battle_weight / sum, level_settings[progress].probability_battle_elite_weight / sum, level_settings[progress].probability_shop_weight / sum, level_settings[progress].probability_bonus_weight / sum, level_settings[progress].probability_campfire_weight / sum])
	instance.type = arr[arr_index]
	
	match instance.type:
		MapNode.Type.BATTLE, MapNode.Type.BATTLE_ELITE:
			if progress == 0:
				instance.string_hint = "wolf1"
			elif progress >= 1 and progress < 5:
				instance.string_hint = early_enemy_pool_keys.pop_back()
				if early_enemy_pool_keys.is_empty():
					for element in temp_early_enemy_keys:
						early_enemy_pool_keys.push_back(element)
					early_enemy_pool_keys.shuffle()
			elif progress >= 5 and progress < 10:
				instance.string_hint = mid_enemy_pool_keys.pop_back()
				if mid_enemy_pool_keys.is_empty():
					for element in temp_mid_enemy_keys:
						mid_enemy_pool_keys.push_back(element)
					mid_enemy_pool_keys.shuffle()
			elif progress >= 10 and progress < 14:
				instance.string_hint = late_enemy_pool_keys.pop_back()
				if late_enemy_pool_keys.is_empty():
					for element in temp_late_enemy_keys:
						late_enemy_pool_keys.push_back(element)
					late_enemy_pool_keys.shuffle()
			elif progress == 14:
				instance.string_hint = "high_druid"
	
	instance.coord = coord
	instance.position = pos
	instance.mouse_entered.connect(func(): node_mouse_entered.emit(instance))
	instance.mouse_exited.connect(func(): node_mouse_exited.emit())
	instance.pressed.connect(func(): node_pressed.emit(instance))
	nodes.push_back(instance)
	return instance


func _draw() -> void:
	#for node in nodes:
	#	for next_node in node.next:
	#		draw_line(node.global_position, next_node.global_position, Color.GRAY)
	
	for key in current_paths:
		var path = current_paths[key]
		var i = 0
		for node in path.nodes:
			if i > 0:
				draw_line(path.nodes[i - 1].global_position, node.global_position, Color.WHITE)
			i += 1
