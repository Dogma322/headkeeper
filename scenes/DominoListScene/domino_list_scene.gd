extends ScreenBase
class_name DominoListScene

const COLUMNS := 8
const SPACING := Vector2(40, 70)  # расстояние между домино

# НАСТРОЙКА ВЫСОТЫ СЕТКИ
@export var CENTER_Y := 120

@onready var dominoes = %Dominoes

var domino_parents = {}
var domino_prev_transforms = {}

enum Source {
	NONE,
	ALL,
	DECK_BAG,
	DISCARD_BAG,
}

var current_source: Source = Source.NONE

func update_domino_list(source: Source) -> void:
	current_source = source
	
	var pool := []
	match source:
		Source.ALL:
			pool = DominoManager.deck
		Source.DECK_BAG:
			pool = DominoManager.temp_deck
		Source.DISCARD_BAG:
			pool = DominoManager.discard
	
	# --- СОРТИРОВКА ПЕРЕД ПОСТРОЕНИЕМ СЕТКИ ---
	pool.sort_custom(func(a, b):
		return a.b < b.b
	)
	
	var total = pool.size()
	
	@warning_ignore("integer_division")
	var rows = ceil(total / COLUMNS)
	var columns = min(total, COLUMNS)

	var center_x = get_viewport_rect().size.x / 2
	var center = Vector2(center_x, CENTER_Y)

	DominoManager.block_domino_input = true

	for i in total:
		var domino: Domino = pool[i]
		domino_prev_transforms[domino] = domino.global_transform
		
		domino.scale = Vector2(1,1)
		domino.visible = true
		if domino.initial_connected_side == 1:
			domino.rotation_degrees = 0
		else:
			domino.rotation_degrees = 180

		domino.scale = Vector2(0,0)

		var tween = get_tree().create_tween()
		tween.tween_property(domino, "scale", Vector2(1.2,1.2), 0.2)
		tween.tween_property(domino, "scale", Vector2(0.8,0.8), 0.1)
		tween.tween_property(domino, "scale", Vector2(1,1), 0.1)

		await get_tree().create_timer(0.01).timeout

		var col = i % COLUMNS
		@warning_ignore("integer_division")
		var row = i / COLUMNS

		var x = (col - (columns - 1) / 2.0) * SPACING.x
		var y = (row - (rows - 1) / 2.0) * SPACING.y

		domino.position = center + Vector2(x, y)

		if domino.get_parent():
			if domino.get_parent() != dominoes:
				domino_parents[domino] = domino.get_parent()
			domino.get_parent().remove_child(domino)

		dominoes.add_child(domino)


func clear_domino_list():
	for domino in dominoes.get_children():
		var tween = get_tree().create_tween()
		tween.tween_property(domino, "scale", Vector2(0,0), 0.2)
		tween.finished.connect(on_tween_finished.bind(domino))
		await get_tree().create_timer(0.05).timeout
	DominoManager.block_domino_input = false


func on_tween_finished(domino) -> void:
	dominoes.remove_child(domino)
	if domino_parents.has(domino):
		domino_parents[domino].add_child(domino)
		domino_parents.erase(domino)
	
	domino.position = domino_prev_transforms[domino].origin
	var tween = get_tree().create_tween()
	tween.tween_property(domino, "scale", Vector2(1,1), 0.2)
	
	domino_prev_transforms.erase(domino)


func end() -> void:
	clear_domino_list()
	current_source = Source.NONE
