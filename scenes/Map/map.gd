extends Control
class_name Map

@export var grid_width := 7
@export var grid_height := 15
@export var min_path_count := 4
@export var max_path_count := 4
@export var branch_count := 3
## Seed for deterministic map generation. Set to 0 for a random seed,
## any other value produces the same map every time for that seed.
@export var map_seed: int = 0
@export var events_seed: int = 0
@export var path_colors: PackedColorArray
@export var build_path_test_mode := false

@export var level_settings: Array[LevelSettings]


@onready var start: Marker2D = $Start
@onready var continue_button: Button = $ContinueButton

signal node_mouse_entered(node: MapNode)
signal node_mouse_exited
signal node_pressed(node: MapNode)
signal continue_pressed
signal path_completed

var nodes = []
var floors = []
var current_paths = []

@onready var temp_early_enemy_keys = EnemyManager.early_enemy_keys.duplicate()
@onready var temp_late_enemy_keys = EnemyManager.late_enemy_keys.duplicate()

var early_enemy_pool_keys = []
var late_enemy_pool_keys = []

@onready var grid_node_scene = preload("res://scenes/Map/map_node.tscn")
@onready var rng := RandomNumberGenerator.new()
@onready var events_rng := RandomNumberGenerator.new()

class MapPath:
	var nodes := []
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
	continue_button.visible = build_path_test_mode
	pass


func _shuffle_rng(arr: Array, _rng: RandomNumberGenerator = null) -> void:
	if _rng == null:
		_rng = rng
	
	# Deterministic Fisher-Yates shuffle that uses the local `rng` instance
	# (Godot's built-in Array.shuffle() relies on the global RNG and would
	# break reproducibility when map_seed is set).
	# Arrays of size 0 or 1 need no shuffling. The early-return also avoids the
	# undefined-behavior path in `randi_range(0, -1)` that would otherwise fire
	# for an empty array (range(-1, 0, -1) yields one iteration with i = -1).
	if arr.size() <= 1:
		return
	for i in range(arr.size() - 1, 0, -1):
		var j := _rng.randi_range(0, i)
		var tmp = arr[i]
		arr[i] = arr[j]
		arr[j] = tmp


func reset_enemy_pools():
	temp_early_enemy_keys = EnemyManager.early_enemy_keys.duplicate()
	temp_late_enemy_keys = EnemyManager.late_enemy_keys.duplicate()

	early_enemy_pool_keys.clear()
	for element in temp_early_enemy_keys:
		early_enemy_pool_keys.push_back(element)
	_shuffle_rng(early_enemy_pool_keys, events_rng)
	late_enemy_pool_keys.clear()
	for element in temp_late_enemy_keys:
		late_enemy_pool_keys.push_back(element)
	_shuffle_rng(late_enemy_pool_keys, events_rng)


func _on_continue_button_pressed() -> void:
	continue_pressed.emit()


func generate_all_points() -> void:
	for y in range(grid_height):
		var arr: Array[MapNode] = []
		for x in range(grid_width):
			var node = add_empty_node(Vector2i(x, y))
			if y > 0:
				if x - 1 >= 0:
					floors[y - 1][x - 1].next.push_back(node)
				floors[y - 1][x].next.push_back(node)
				if x + 1 < grid_width:
					floors[y - 1][x + 1].next.push_back(node)
			node.to_erase = true
			
			arr.push_back(node)
		floors.push_back(arr)


func mark_started_points() -> void:
	# Number of starting paths to spawn, derived from the @export bounds.
	# When the bounds differ, draw the actual count from the deterministic
	# `rng` so the same seed produces the same number of paths.
	var path_count := 0
	if min_path_count == max_path_count:
		path_count = min(max_path_count, floors[0].size())
	else:
		path_count = rng.randi_range(min(min_path_count, grid_width), min(max_path_count, grid_width))
	path_count = min(path_count, floors[0].size())

	var pool: Array[MapNode] = floors[0].duplicate()
	_shuffle_rng(pool)
	for i in range(path_count):
		pool[i].shadowed = false


func build_path(floor_index: int, path: MapPath) -> bool:
	if floor_index == floors.size():
		path_completed.emit()
		return true
	var node = path.nodes[-1]
	var x = node.coord.x
	var start_offset := 0
	var count := 0
	if x == 0:
		count = 2
	elif x == grid_width - 1:
		count = 2
		start_offset = -1
	else:
		count = 3
		start_offset = -1
	var potential = []
	for i in range(count):
		potential.push_back(floors[floor_index][x + start_offset + i])
	
	if build_path_test_mode:
		print("\nNEXT\n")
		
	var candidates: Array[MapNode] = []
	for i in range(count):
		var candidate = floors[floor_index][x + start_offset + i]
		
		var intersection := false
		for other_path in current_paths:
			if other_path == path:
				continue
			if other_path.nodes.size() > floor_index:
				if not potential.has(candidate):
					continue
				if other_path.nodes[floor_index - 1].coord.x == node.coord.x:
					# Линии идут из одинаковой точки - разрешить.
					continue
				if other_path.nodes[floor_index].coord.x == candidate.coord.x:
					continue
				if Geometry2D.segment_intersects_segment(Vector2(other_path.nodes[floor_index - 1].coord), Vector2(other_path.nodes[floor_index].coord), Vector2(node.coord), Vector2(candidate.coord)) != null:
					intersection = true
					break
			if intersection:
				break
		if not intersection:
			candidates.push_back(candidate)
			if build_path_test_mode:
				print(candidate.coord)
			
		
	_shuffle_rng(candidates)
	var chosen = candidates[0]
	chosen.shadowed = false
	path.nodes.push_back(chosen)
	queue_redraw()
	if build_path_test_mode:
		await continue_pressed
	return await build_path(floor_index + 1, path)


func build_paths() -> void:
	for node: MapNode in floors[0]:
		if node.shadowed:
			continue
		var color = Color.WHITE
		#if path_colors.size() >= current_paths.size():
		#	var index = current_paths.size()
		#	color = path_colors[index]
		var path = MapPath.new([node], color)
		current_paths.push_back(path)
		build_path(1, path)
		if build_path_test_mode:
			await path_completed


func build_events() -> void:
	for path in current_paths:
		for node in path.nodes:
			if not node.generated:
				setup_node(node)


func remove_unconnected_nodes() -> void:
	for arr: Array in floors:
		for node in arr:
			if node.to_erase:
				node.queue_free()
				nodes.erase(node)


func generate(passed_map_seed: int = 0, passed_events_seed: int = 0) -> void:
	var resolved_map_seed: int = passed_map_seed if passed_map_seed != 0 else map_seed
	if resolved_map_seed != 0:
		rng.seed = resolved_map_seed
	else:
		rng.randomize()
	
	var resolved_events_seed: int = passed_events_seed if passed_map_seed != 0 else events_seed
	if resolved_events_seed != 0:
		events_rng.seed = resolved_events_seed
	else:
		events_rng.randomize()

	clear()
	reset_enemy_pools()

	generate_all_points()
	mark_started_points()
	build_paths()
	if build_path_test_mode:
		return
	build_events()
	remove_unconnected_nodes()
	
	var boss_node = add_empty_node(Vector2i(roundi(grid_width / 2.0) - 1, grid_height))
	boss_node.shadowed = false
	setup_node(boss_node)
	
	for path: MapPath in current_paths:
		path.nodes.push_back(boss_node)
	
	queue_redraw()


func add_empty_node(coord: Vector2i) -> MapNode:
	var offset2 := get_viewport_rect().size.x / 10.0
	var pos = Vector2(coord.x * 20 - offset2, -coord.y * 20)
	
	var instance: MapNode = grid_node_scene.instantiate()
	start.add_child(instance)
	instance.shadowed = true
	instance.coord = coord
	instance.position = pos
	nodes.push_back(instance)
	return instance


func setup_node(instance) -> void:
	var progress = instance.coord.y
	
	# --------------
	# MapNode.Type
	# --------------
	# UNKNOWN = -1,
	# BATTLE,
	# BATTLE_ELITE,
	# SHOP,
	# HEADS,
	# POND,
	# EVENT,
	# MAX
	# --------------
	
	var arr = [MapNode.Type.BATTLE, MapNode.Type.BATTLE_ELITE, MapNode.Type.SHOP, MapNode.Type.HEADS, MapNode.Type.POND, MapNode.Type.EVENT]
	var sum = level_settings[progress].probability_sum()
	var arr_index = events_rng.rand_weighted([
		level_settings[progress].probability_battle_weight / sum,
		level_settings[progress].probability_battle_elite_weight / sum,
		level_settings[progress].probability_shop_weight / sum,
		level_settings[progress].probability_bonus_weight / sum,
		level_settings[progress].probability_campfire_weight / sum,
		level_settings[progress].probability_event_weight / sum])
	instance.type = arr[arr_index]
	
	match instance.type:
		MapNode.Type.EVENT:
			var events: Dictionary = Run.reserved_events_pool
			var pool = []
			for key: String in events.keys():
				if EventsManager.events[key].act == Run.act:
					pool.push_back(key)
			_shuffle_rng(pool, events_rng)
			instance.string_hint = pool[0]
		MapNode.Type.BATTLE, MapNode.Type.BATTLE_ELITE:
			if progress == 14:
				instance.is_final = true
				instance.string_hint = "boss1"
			elif Run.battle_count < 3:
				instance.string_hint = early_enemy_pool_keys.pop_back()
				if early_enemy_pool_keys.is_empty():
					for element in temp_early_enemy_keys:
						early_enemy_pool_keys.push_back(element)
					_shuffle_rng(early_enemy_pool_keys, events_rng)
			else:
				instance.string_hint = late_enemy_pool_keys.pop_back()
				if late_enemy_pool_keys.is_empty():
					for element in temp_late_enemy_keys:
						late_enemy_pool_keys.push_back(element)
					_shuffle_rng(late_enemy_pool_keys, events_rng)
	
	instance.mouse_entered.connect(func(): node_mouse_entered.emit(instance))
	instance.mouse_exited.connect(func(): node_mouse_exited.emit())
	instance.pressed.connect(func(): node_pressed.emit(instance))
	
	instance.generated = true
	instance.to_erase = false


func _draw() -> void:
	#for node in nodes:
	#	for next_node in node.next:
	#		draw_line(node.global_position, next_node.global_position, Color.GRAY)
	for path in current_paths:
		var i = 0
		for node in path.nodes:
			if i > 0:
				draw_line(path.nodes[i - 1].global_position, node.global_position, Color(Color.WHITE, 0.25), 2.0)
			i += 1
