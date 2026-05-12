extends ScreenBase
class_name ItemListScene

const COLUMNS := 8
const SPACING := Vector2(40, 70)  # расстояние между предметами

# НАСТРОЙКА ВЫСОТЫ СЕТКИ
@export var CENTER_Y := 120

@onready var items = %Items

var item_list = []

enum Mode {
	NONE,
	HEADS,
	BONUSES,
	DOMINO
}

var current_mode = Mode.NONE

enum DominoSource {
	NONE,
	ALL,
	DECK_BAG,
	DISCARD_BAG,
}

var current_domino_source: DominoSource = DominoSource.NONE

signal all_items_cleared

func update_head_list() -> void:
	if current_mode != Mode.NONE:
		await Transition.blackout()
		clear_item_list()
		await all_items_cleared
	
	current_mode = Mode.HEADS
	
	var pool := []
	for key in Run.current_head_pool_keys:
		pool.push_back(HeadManager.head_pool[key].instantiate())

	var total = pool.size()
	
	@warning_ignore("integer_division")
	var rows = ceil(total / COLUMNS)
	var columns = min(total, COLUMNS)

	var center_x = get_viewport_rect().size.x / 2
	var center = Vector2(center_x, CENTER_Y)
	
	for i in total:
		var head: Head = pool[i]
		head.scale = Vector2(1,1)
		head.visible = true

		head.scale = Vector2(0,0)

		var tween = get_tree().create_tween()
		tween.tween_property(head, "scale", Vector2(1.2,1.2), 0.2)
		tween.tween_property(head, "scale", Vector2(0.8,0.8), 0.1)
		tween.tween_property(head, "scale", Vector2(1,1), 0.1)

		await get_tree().create_timer(0.01).timeout

		var col = i % COLUMNS
		@warning_ignore("integer_division")
		var row = i / COLUMNS

		var x = (col - (columns - 1) / 2.0) * SPACING.x
		var y = (row - (rows - 1) / 2.0) * SPACING.y

		head.position = center + Vector2(x, y)
		items.add_child(head)
		item_list.append(head)


func update_bonus_list() -> void:
	if current_mode != Mode.NONE:
		await Transition.blackout()
		clear_item_list()
		await all_items_cleared
	
	current_mode = Mode.BONUSES
	
	var pool := []
	for scene in BoardManager.bonus_pool:
		pool.push_back(scene.instantiate())
	
	var total = pool.size()
	
	@warning_ignore("integer_division")
	var rows = ceil(total / COLUMNS)
	var columns = min(total, COLUMNS)

	var center_x = get_viewport_rect().size.x / 2
	var center = Vector2(center_x, CENTER_Y)
	
	for i in total:
		var bonus: BoardBonus = pool[i]
		bonus.scale = Vector2(1,1)
		bonus.visible = true

		bonus.scale = Vector2(0,0)

		var tween = get_tree().create_tween()
		tween.tween_property(bonus, "scale", Vector2(1.2,1.2), 0.2)
		tween.tween_property(bonus, "scale", Vector2(0.8,0.8), 0.1)
		tween.tween_property(bonus, "scale", Vector2(1,1), 0.1)

		await get_tree().create_timer(0.01).timeout

		var col = i % COLUMNS
		@warning_ignore("integer_division")
		var row = i / COLUMNS

		var x = (col - (columns - 1) / 2.0) * SPACING.x
		var y = (row - (rows - 1) / 2.0) * SPACING.y

		bonus.position = center + Vector2(x, y)
		items.add_child(bonus)
		item_list.append(bonus)


func update_domino_list(source: DominoSource) -> void:
	if current_mode != Mode.NONE:
		await Transition.blackout()
		clear_item_list()
		await all_items_cleared
	
	current_mode = Mode.DOMINO
	current_domino_source = source
	
	var source_pool := []
	match source:
		DominoSource.ALL:
			source_pool = DominoManager.deck
		DominoSource.DECK_BAG:
			source_pool = DominoManager.temp_deck
		DominoSource.DISCARD_BAG:
			source_pool = DominoManager.discard
	
	var pool := []
	for item: Domino in source_pool:
		var domino: Domino = Global.domino_scene.instantiate()
		items.add_child(domino)
		domino.setup(Domino.SideSettings.new(item.a_types, item.a_color), Domino.SideSettings.new(item.b_types, item.b_color))
		pool.push_back(domino)
	
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
		item_list.append(domino)


func clear_item_list():
	if items.get_child_count() > 0:
		for item in items.get_children():
			var tween = get_tree().create_tween()
			tween.tween_property(item, "scale", Vector2(0,0), 0.2)
			tween.finished.connect(on_tween_finished.bind(item))
			await get_tree().create_timer(0.05).timeout
	else:
		await get_tree().create_timer(0.2).timeout
		all_items_cleared.emit()


func on_tween_finished(item) -> void:
	item.queue_free()
	item_list.erase(item)
	if item_list.is_empty():
		all_items_cleared.emit()


func end() -> void:
	clear_item_list()
	if current_mode == Mode.DOMINO:
		DominoManager.block_domino_input = false
		current_domino_source = DominoSource.NONE
