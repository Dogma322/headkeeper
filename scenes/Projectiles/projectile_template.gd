extends Node2D

@export var speed := 1250
@export var trail_length := 12

@onready var trail: Line2D = $Trail
@onready var bullet_data: Dictionary




func _ready():
	# ВАЖНО: хвост живёт в мировых координатах
	trail.top_level = true


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
