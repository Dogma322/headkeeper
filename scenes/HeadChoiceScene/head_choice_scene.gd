extends ScreenBase
class_name ChoiceScene

@export var spacing = 100
@export var y_position := 180

@export var float_amplitude := 8
@export var float_speed := 2.0

var choices: Array = []
var base_positions: Array[Vector2] = []
var offsets: Array = []

var time := 0.0

var choosing := false
var spawning := false
var choice_locked := false

func _ready() -> void:
	Global.choice_scene = self


func clear_choices():

	for c in choices:
		if is_instance_valid(c):
			c.queue_free()

	choices.clear()
	base_positions.clear()
	offsets.clear()



func spawn_heads():

	clear_choices()

	spawning = true
	choice_locked = false

	for i in range(3):
		var keys =  Run.reserved_head_pool.keys()
		var random_key = keys.pick_random()
		var head_scene = HeadManager.head_pool[random_key]

		Run.reserved_head_pool.erase(random_key)

		var head = head_scene.instantiate()


		#var scene = Run.reserved_head_pool.values().pick_random()
		#var head = scene.instantiate()

		head.scale = Vector2.ZERO
		head.head_choice = true

		add_child(head)

		choices.append(head)

	align_choices()
	await animate_spawn()



func spawn_dominoes():

	clear_choices()

	spawning = true
	choice_locked = false

	var temp_dominoes = DominoManager.domino_templates.values().duplicate()

	for i in range(3):

		var template = temp_dominoes.pick_random()
		temp_dominoes.erase(template) # чтобы не выбрать ту же карту дважды

		var domino: Domino = Global.domino_scene.instantiate()
		domino.template = template

		#var scene = DominoManager.temp_domino_pool.values().pick_random()
		#var domino = scene.instantiate()

		domino.scale = Vector2.ZERO
		domino.domino_choice = true

		add_child(domino)

		choices.append(domino)

	align_choices()
	await animate_spawn()



func align_choices():

	base_positions.clear()
	offsets.clear()

	var screen = get_viewport_rect().size
	var total_width = (choices.size() - 1) * spacing
	var start_x = screen.x / 2 - total_width / 2

	for i in range(choices.size()):

		var obj = choices[i]

		if not is_instance_valid(obj):
			continue

		var pos = Vector2(
			start_x + i * spacing,
			y_position
		)

		obj.position = pos

		base_positions.append(pos)
		offsets.append(randf() * TAU)



func animate_spawn():

	for i in range(choices.size()):

		if i >= choices.size():
			break

		var obj = choices[i]

		if not is_instance_valid(obj):
			continue

		var tween = create_tween()

		tween.tween_property(
			obj,
			"scale",
			Vector2.ONE,
			0.35
		).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

		await get_tree().create_timer(0.08).timeout

	spawning = false
	choosing = true



func choice_selected(selected):

	if spawning:
		return

	if not choosing:
		return

	if choice_locked:
		return

	choice_locked = true
	choosing = false

	for obj in choices:

		if obj == selected:
			continue

		if obj is Domino:
			obj.domino_choice = false

		if obj is Head:
			obj.head_choice = false

	choices.erase(selected)

	for obj in choices:

		if not is_instance_valid(obj):
			continue

		var tween = create_tween()

		tween.tween_property(
			obj,
			"scale",
			Vector2.ZERO,
			0.25
		).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)

		await tween.finished

		if is_instance_valid(obj):
			obj.queue_free()

	choices.clear()
	base_positions.clear()
	offsets.clear()



func _process(delta):

	time += delta * float_speed

	for i in range(choices.size()):

		if i >= base_positions.size():
			return

		var obj = choices[i]

		if not is_instance_valid(obj):
			continue

		var base = base_positions[i]

		obj.position.y = base.y + sin(time + offsets[i]) * float_amplitude
