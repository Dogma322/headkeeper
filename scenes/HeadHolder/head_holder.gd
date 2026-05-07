@tool
extends Node2D

@onready var marker_2d: Marker2D = $Marker2D

@export var center_position: Vector2 = Vector2(100, 116):  # Точка, относительно которой выравниваются головы
	set(value):
		center_position = value
		if is_instance_valid(marker_2d):
			marker_2d.global_position = center_position
		
@export var hand_width: float = 200                   # ширина зоны, в которой будут головы
@export var amplitude: float = 3                      # амплитуда синусоиды
@export var spacing: float = 35                       # расстояние между головами
@export var move_duration: float = 0.4                # время движения твина
@export_enum("Hero", "Center", "Enemy") var holder_type := "Hero"

var time: float = 0.0

func _ready() -> void:
	marker_2d.global_position = center_position
	if not Engine.is_editor_hint():
		match holder_type:
			"Hero":
				Global.head_holder = self
			"Center":
				Global.center_head_holder = self
			"Enemy":
				Global.enemy_head_holder = self

func _process(delta: float) -> void:
	time += delta
	update_head_positions()

func update_head_positions() -> void:
	var heads: Array = get_children().filter(func(c): return c is Head)
	var total_heads: int = heads.size()
	if total_heads == 0:
		return

	var total_width: float = (total_heads - 1) * spacing
	var start_x: float = center_position.x - total_width / 2.0  # теперь центр относительно указанной точки

	for i in range(total_heads):
		var head: Node2D = heads[i]
		var target_x: float = start_x + i * spacing
		var target_y: float = center_position.y + sin(time * 3 + i * 0.5) * amplitude
		var target_position: Vector2 = Vector2(target_x, target_y)

		# создаем твины для плавного перемещения
		var tween := get_tree().create_tween()
		tween.set_parallel()
		tween.tween_property(head, "position", target_position, move_duration)
