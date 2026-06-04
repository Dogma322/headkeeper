@tool
extends ScreenBase

## Экран инвентаря.

@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var v_scroll_bar: VScrollBar = %VScrollBar
@onready var domino_container: HFlowContainer = %DominoContainer

@onready var heads_label: Label = %HeadsLabel
@onready var heads_container: HBoxContainer = %HeadsContainer

@onready var bonuses_container: HFlowContainer = %BonusesContainer

@export_range(1.0, 100.0) var shrink_amount = 5.0
@export_range(0.0, 100.0) var dec_amount = 1.612

const DOMINO_CONTAINER = preload("uid://qh0ecd074sot")
const HEAD_CONTAINER = preload("uid://bpdrdg014nrh8")

var dominoes = []
var heads = []
var bonuses = []

func _ready() -> void:
	scroll_container.get_v_scroll_bar().value_changed.connect(_on_builtin_scrollbar_value_changed)
	v_scroll_bar.value_changed.connect(_on_custom_scrollbar_value_changed)


func start() -> void:
	update_domino_list()
	update_head_list()
	update_bonus_list()


func before_end():
	clear_domino_list()
	clear_head_list()
	clear_bonus_list()

	
func end() -> void:
	for domino in dominoes:
		domino.queue_free()
	dominoes.clear()
	DominoManager.block_domino_input = false

	for head in heads:
		head.queue_free()
	heads.clear()
	
	for bonus in bonuses:
		bonus.queue_free()
	bonuses.clear()


func update_domino_list() -> void:
	var source_pool = DominoManager.deck
	
	var pool := []
	for item: Domino in source_pool:
		var container = DOMINO_CONTAINER.instantiate()
		container.name = "DominoContainer"
		domino_container.add_child(container)
		pool.push_back(container)
		
		var domino: Domino = Global.domino_scene.instantiate()
		container.domino = domino
		container.add_child(domino)
		domino.position += Vector2(16, 32)
		domino.trail_particles.hide()
		domino.trail.hide()
		domino.setup(Domino.SideSettings.new(item.a_types, item.a_color), Domino.SideSettings.new(item.b_types, item.b_color))
	
	# --- СОРТИРОВКА ПЕРЕД ПОСТРОЕНИЕМ СЕТКИ ---
	pool.sort_custom(func(a, b):
		return a.domino.b < b.domino.b
	)
	
	var total = pool.size()

	DominoManager.block_domino_input = true

	for i in total:
		var container = pool[i]
		var domino: Domino = container.domino
		domino.scale = Vector2(1,1)
		domino.visible = true
		
		if domino.initial_connected_side == 1:
			domino.rotation_degrees = 0
		else:
			domino.rotation_degrees = 180

		domino.scale = Vector2(0,0)
		domino.area_2d.input_pickable = false

		var tween = get_tree().create_tween()
		tween.tween_property(domino, "scale", Vector2(1.2,1.2), 0.2)
		tween.tween_property(domino, "scale", Vector2(0.8,0.8), 0.1)
		tween.tween_property(domino, "scale", Vector2(1,1), 0.1)

		await get_tree().create_timer(0.01).timeout
		dominoes.append(container)


func update_head_list() -> void:
	var pool := []
	for key in Run.current_head_pool_keys:
		var container: HeadContainer = HEAD_CONTAINER.instantiate()
		container.name = "HeadContainer"
		heads_container.add_child(container)
		pool.push_back(container)
		
		var head: Head = HeadManager.head_pool[key].instantiate()
		head.position += Vector2(16, 16)
		container.head = head
		container.add_child(head)

	var total = pool.size()
	heads_label.text = tr(&"ID_HEADS") % [total, 5]

	for i in total:
		var container = pool[i]
		var head: Head = container.head
		head.scale = Vector2(1,1)
		head.visible = true

		head.scale = Vector2(0,0)
		head.des_area.input_pickable = false
		
		var tween = get_tree().create_tween()
		tween.tween_property(head, "scale", Vector2(1.2,1.2), 0.2)
		tween.tween_property(head, "scale", Vector2(0.8,0.8), 0.1)
		tween.tween_property(head, "scale", Vector2(1,1), 0.1)

		await get_tree().create_timer(0.01).timeout
		heads.append(container)


func update_bonus_list() -> void:
	var pool := []
	for scene in BoardManager.bonus_pool:
		var bonus: BoardBonus = scene.instantiate()
		bonuses_container.add_child(bonus)
		bonus.custom_minimum_size = Vector2(28, 28)
		pool.push_back(bonus)
	
	var total = pool.size()
	
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
		bonuses.append(bonus)

func clear_domino_list() -> void:
	for container in dominoes:
		var tween = get_tree().create_tween()
		tween.tween_property(container.domino, "scale", Vector2(0,0), 0.2)
		await get_tree().create_timer(0.05).timeout


func clear_head_list() -> void:
	for container in heads:
		var tween = get_tree().create_tween()
		tween.tween_property(container.head, "scale", Vector2(0,0), 0.2)
		await get_tree().create_timer(0.05).timeout


func clear_bonus_list() -> void:
	for container in bonuses:
		var tween = get_tree().create_tween()
		tween.tween_property(container, "scale", Vector2(0,0), 0.2)
		await get_tree().create_timer(0.05).timeout


func _physics_process(_delta: float) -> void:
	var built_in = scroll_container.get_v_scroll_bar()
	if built_in.max_value <= scroll_container.size.y:
		v_scroll_bar.modulate.a = 0.0
		return
	v_scroll_bar.modulate.a = 1.0
	if v_scroll_bar.max_value != built_in.max_value:
		v_scroll_bar.max_value = built_in.max_value
	if v_scroll_bar.page != built_in.page:
		v_scroll_bar.page = built_in.page
	if v_scroll_bar.step != built_in.step:
		v_scroll_bar.step = built_in.step


func _on_builtin_scrollbar_value_changed(value: float) -> void:
	v_scroll_bar.value = value


func _on_custom_scrollbar_value_changed(value: float) -> void:
	scroll_container.scroll_vertical = int(value)
