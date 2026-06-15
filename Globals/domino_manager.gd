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

@onready var start_deck := {}
@onready var domino_templates := {}


func _ready() -> void:
	Global.load_templates("res://resources/dominoes", domino_templates, ["start"])
	Global.load_templates("res://resources/dominoes/start", start_deck)
	reset()
	Signals.reset_run_data.connect(reset)


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
	Signals.deck_changed.emit()


func reshuffle_discard_into_deck():
	# Добавляем все кости из discard в deck
	for bone in discard:
		temp_deck.append(bone)
	
	# Очищаем discard
	clear_discard()
	
	# Перемешиваем колоду
	temp_deck.shuffle()
	Signals.deck_changed.emit()


func reset_turn_data():
	pass


func reset_run_data():
	pass
