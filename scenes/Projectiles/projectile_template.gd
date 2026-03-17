extends Node2D

@export var speed := 1250
@export var trail_length := 12


@onready var sprite = $Sprite2D
@onready var trail = $Trail


func _ready():
	# ВАЖНО: хвост живёт в мировых координатах
	trail.top_level = true

func set_proj(action):
	var color: Color
	
	if action is AttackAction:
		color = Color.RED
	elif action is BlockAction:
		color = Color.BLUE
	elif action is HealAction:
		color = Color.GREEN
	elif action is BuffAction:
		color = Color.ORANGE
	elif action is DebuffAction or action is AttackDebuffAction:
		color = Color.PURPLE
	else:
		color = Color.WHITE
	
	apply_color(color)


func apply_color(color: Color):
	# меняем цвет спрайта
	sprite.modulate = color
	# меняем цвет трейла
	trail.default_color = color


func fly(from: Vector2, to: Vector2):

	global_position = from
	trail.clear_points()

	var distance = from.distance_to(to)
	var duration = distance / speed

	var tween = create_tween()
	tween.tween_property(
		self,
		"global_position",
		to,
		duration
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

	await tween.finished
	Signals.projectile_hit.emit()
	
	queue_free()


func _process(_delta):
	update_trail()


func update_trail():
	# теперь добавляем мировую позицию
	trail.add_point(global_position)

	if trail.get_point_count() > trail_length:
		trail.remove_point(0)
