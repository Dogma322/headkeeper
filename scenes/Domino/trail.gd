@tool
extends Line2D

var prev_pos: Vector2 = Vector2.ZERO
var radius: float = 0.0

@export var max_width: float = 60.0
@export var velocity_threshold: float = 200.0
@export var max_trail_points: int = 30
@export var fade_speed: float = 300.0

@export var particles: GPUParticles2D

var target_width: float = max_width

func _ready() -> void:
	radius = 1.0 * 0.5
	prev_pos = get_parent().global_position

func _process(delta: float) -> void:
	var current_pos = get_parent().global_position
	var delta_pos = current_pos - prev_pos
	
	var is_fast_movement = delta_pos.length() >= velocity_threshold * delta
	
	if is_fast_movement:
		var dir = delta_pos.normalized()
		
		# Enable particles during movement
		if particles:
			particles.emitting = true
		
		# Width based on movement direction:
		# horizontal (abs(dir.x) = 1) -> max width, vertical (abs(dir.y) = 1) -> half width
		var horizontal_factor = abs(dir.x)
		var width_multiplier = lerp(0.5, 1.0, horizontal_factor)
		target_width = max_width * width_multiplier
		
		add_point(get_parent().global_position - radius * dir)
		if points.size() > max_trail_points:
			remove_point(0)
	else:
		# Disable particles when stopped
		if particles:
			particles.emitting = false
		
		# Fade out remaining trail
		target_width = maxf(0.0, target_width - fade_speed * delta)
		
		if target_width <= 0.0 and points.size() > 0:
			remove_point(0)
	
	# Smoothly interpolate current width to target
	width = lerpf(width, target_width, 1.0 - exp(-10.0 * delta))
	
	prev_pos = current_pos
