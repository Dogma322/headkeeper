extends Node2D

const COLUMNS := 8
const SPACING := Vector2(40, 70)  # расстояние между домино

# НАСТРОЙКА ВЫСОТЫ СЕТКИ
@export var CENTER_Y := 120

@onready var dominoes = $Dominoes

var removed_domino_counter = 0


func _ready():
	Signals.domino_deleted_from_deck.connect(clear_domino_list)
	Global.remove_domino_scene = self
	
	
func update_domino_list():

	# --- СОРТИРОВКА ПЕРЕД ПОСТРОЕНИЕМ СЕТКИ ---
	DominoManager.temp_deck.sort_custom(func(a, b):
		return a.b < b.b
	)

	var total = DominoManager.temp_deck.size()
	var rows = ceil(total / COLUMNS)
	var columns = min(total, COLUMNS)

	var center_x = get_viewport_rect().size.x / 2
	var center = Vector2(center_x, CENTER_Y)

	for i in total:
		var domino = DominoManager.temp_deck[i]
		domino.scale = Vector2(1,1)
		domino.visible = true
		domino.rotation_degrees = 0

		DominoManager.delete_mode = true

		domino.scale = Vector2(0,0)

		var tween = get_tree().create_tween()
		tween.tween_property(domino, "scale", Vector2(1.2,1.2), 0.2)
		tween.tween_property(domino, "scale", Vector2(0.8,0.8), 0.1)
		tween.tween_property(domino, "scale", Vector2(1,1), 0.1)

		await get_tree().create_timer(0.01).timeout

		var col = i % COLUMNS
		var row = i / COLUMNS

		var x = (col - (columns - 1) / 2.0) * SPACING.x
		var y = (row - (rows - 1) / 2.0) * SPACING.y

		domino.position = center + Vector2(x, y)

		if domino.get_parent():
			domino.get_parent().remove_child(domino)

		dominoes.add_child(domino)


func clear_domino_list():
	
	removed_domino_counter += 1
	
	if removed_domino_counter < 2:
		return
	else:
		DominoManager.delete_mode = false
		DominoManager.block_domino_input = true
		removed_domino_counter = 0
		await get_tree().create_timer(0.7).timeout
		

		for domino in dominoes.get_children():
			if domino.get_parent() == dominoes:
				
				var tween = get_tree().create_tween()
				tween.tween_property(domino, "scale", Vector2(0,0), 0.2)
				
				await get_tree().create_timer(0.05).timeout
				
				dominoes.remove_child(domino)
				Global.add_child(domino)

		DominoManager.block_domino_input = false
		
		Signals.domino_delete_completed.emit()
		await get_tree().create_timer(1).timeout
		CombatManager.change_stage()
