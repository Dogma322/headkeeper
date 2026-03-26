extends Control
class_name DominoListScene

const COLUMNS := 8
const SPACING := Vector2(40, 70)  # расстояние между домино

# НАСТРОЙКА ВЫСОТЫ СЕТКИ
@export var CENTER_Y := 120

@onready var dominoes = $Dominoes
@onready var exit_button: TextureButton = %ExitButton

var domino_parents = []
var domino_buffer = []
var domino_prev_transforms = []

enum Source {
	ALL,
	DECK_BAG,
	DISCARD_BAG,
}

func _ready():
	pass
	
	
func update_domino_list(source: Source):
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
		domino_prev_transforms.push_back(domino.global_transform)
		
		domino.scale = Vector2(1,1)
		domino.visible = true
		domino.rotation_degrees = 0

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
			domino_parents.push_back(domino.get_parent())
			domino.get_parent().remove_child(domino)
		else:
			domino_parents.push_back(null)

		dominoes.add_child(domino)


func clear_domino_list():
	var i := 0
	for domino in dominoes.get_children():
		domino_buffer.push_back(domino)
	
	for domino in dominoes.get_children():
		var tween = get_tree().create_tween()
		tween.tween_property(domino, "scale", Vector2(0,0), 0.2)
		
		await get_tree().create_timer(0.05).timeout
		
		dominoes.remove_child(domino)
		if domino_parents[i] != null:
			domino_parents[i].add_child(domino)
		i += 1
	DominoManager.block_domino_input = false


func _on_exit_button_mouse_entered() -> void:
	exit_button.modulate = Color(1.3, 1.3, 1.3)


func _on_exit_button_mouse_exited() -> void:
	exit_button.modulate = Color(1.0, 1.0, 1.0)


func _on_exit_button_pressed() -> void:
	clear_domino_list()
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	Transition.blackout_off()
	hide()
	Global.fight_scene.show_ui()
	
	var i := 0
	for domino: Domino in domino_buffer:
		domino.global_transform = domino_prev_transforms[i]
		i += 1
	domino_parents.clear()
	domino_prev_transforms.clear()
	domino_buffer.clear()
