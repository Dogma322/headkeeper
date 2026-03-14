extends Node2D


@export var min_heads := 3
@export var max_heads := 5

@export var spacing := 80
@export var y_position := 160

@export var float_amplitude := 10
@export var float_speed := 2.0

var heads: Array = []
var base_positions: Array[Vector2] = []
var offsets: Array = []
var time := 0.0


func generate_heads():
	pass

func spawn_heads():

	clear_heads()

	var count = randi_range(min_heads, max_heads)


	for i in range(count):

		var scene = HeadManager.temp_head_pool.pick_random()
		HeadManager.temp_head_pool.erase(scene)

		var head = scene.instantiate()

		head.head_choice = true

		add_child(head)

		heads.append(head)

	align_heads()


func align_heads():

	base_positions.clear()
	offsets.clear()

	var screen_width = get_viewport_rect().size.x

	var total_width = (heads.size() - 1) * spacing

	var start_x = screen_width / 2 - total_width / 2

	for i in range(heads.size()):

		var head = heads[i]

		var pos = Vector2(
			start_x + i * spacing,
			y_position
		)

		head.position = pos

		base_positions.append(pos)

		offsets.append(randf() * TAU)


func _process(delta):

	time += delta * float_speed

	for i in range(heads.size()):

		var head = heads[i]

		if not is_instance_valid(head):
			continue

		var base = base_positions[i]

		head.position.y = base.y + sin(time + offsets[i]) * float_amplitude


func clear_heads():

	for head in heads:
		if is_instance_valid(head):
			head.queue_free()

	heads.clear()
	base_positions.clear()
	offsets.clear()
