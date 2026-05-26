extends Node

var dominoes_on_board = []
var deck = []
var temp_deck = []
var discard = []

var draw_counter = 5
var bonus_draw_counter = 0
var head_draw_counter = 0
var head_draw_counter_dec = 0
var head_discard_draw_counter = 0

var value1_played_dominoes = 0
var value2_played_dominoes = 0
var value3_played_dominoes = 0
var value4_played_dominoes = 0


var dm_dragging = false
var block_domino_input = false
var delete_mode = false
	

var double_next_dm = 0
var corruption_bonus = 0

@onready var start_deck := {
	"2_1_atk" : preload("res://resources/dominoes/start/dm_start_2_1_attack.tres"),
	"2_1_def" : preload("res://resources/dominoes/start/dm_start_2_1_defense.tres"),
	"3_1_atk" : preload("res://resources/dominoes/start/dm_start_3_1_attack.tres"),
	"3_1_def" : preload("res://resources/dominoes/start/dm_start_3_1_defense.tres"),
	"3_2_atk" : preload("res://resources/dominoes/start/dm_start_3_2_attack.tres"),
	"3_2_def" : preload("res://resources/dominoes/start/dm_start_3_2_defense.tres"),
	"4_2_atk_vulnerable": preload("res://resources/dominoes/start/dm_start_4_2_attack_vulnerable.tres"),
	"4_2_def_heal" : preload("res://resources/dominoes/start/dm_start_4_2_defense_heal.tres"),
}

@onready var domino_templates := {}

#var temp_domino_pool 

func _ready() -> void:
	load_domino_templates()
	reset()
	Signals.reset_run_data.connect(reset)

func load_domino_templates() -> void:
	var dir_path = "res://resources/dominoes"
	var dir = DirAccess.open(dir_path)
	if dir == null:
		push_warning("Could not open directory: " + dir_path)
		return
	
	domino_templates.clear()
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			# Skip 'start' folder
			if file_name != "start":
				load_templates_from_subdir(dir_path + "/" + file_name)
		else:
			# Check if it's a .tres file in root dominoes folder
			if file_name.ends_with(".tres"):
				var key = file_name.get_basename()
				var resource_path = dir_path + "/" + file_name
				domino_templates[key] = load(resource_path)
		file_name = dir.get_next()
	dir.list_dir_end()

func load_templates_from_subdir(subdir_path: String) -> void:
	var subdir = DirAccess.open(subdir_path)
	if subdir == null:
		return
	
	subdir.list_dir_begin()
	var file_name = subdir.get_next()
	while file_name != "":
		if not subdir.current_is_dir() and file_name.ends_with(".tres"):
			var key = file_name.get_basename()
			var resource_path = subdir_path + "/" + file_name
			domino_templates[key] = load(resource_path)
		file_name = subdir.get_next()
	subdir.list_dir_end()

func add_to_discard(domino: Domino) -> void:
	discard.append(domino)
	Signals.discard_deck_changed.emit()


func remove_from_discard(domino: Domino) -> void:
	discard.erase(domino)
	Signals.discard_deck_changed.emit()


func clear_discard() -> void:
	discard.clear()
	Signals.discard_deck_changed.emit()


func reset():
	#temp_domino_pool = domino_templates.duplicate()
	
	dominoes_on_board.clear()
	temp_deck.clear()
	deck.clear()
	clear_discard()
	
	Global.hand.dominoes.clear()
	for dm in Global.hand.get_children():
		dm.queue_free()
	
	set_deck()

func set_deck():
	for i in range(1): 
		for key in start_deck.keys():
			var domino: Domino 
			if start_deck[key] is DominoTemplate:
				domino = Global.domino_scene.instantiate()
				domino.template = start_deck[key]
			else:
				domino = start_deck[key].instantiate()
			domino.global_position.y = -100000 # HACK: чтобы не было краша игры при наведении на край экрана.
			add_child(domino)
			deck.append(domino)
		
	temp_deck = deck.duplicate()


func reshuffle_discard_into_deck():
	# Добавляем все кости из discard в deck
	for bone in discard:
		temp_deck.append(bone)
	
	# Очищаем discard
	clear_discard()
	
	# Перемешиваем колоду
	temp_deck.shuffle()


func reset_turn_data():
	pass
	
func reset_run_data():
	pass
