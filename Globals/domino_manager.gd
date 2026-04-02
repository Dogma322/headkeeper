extends Node

var dominoes_on_board = []
var deck = []
var temp_deck = []
var discard = []
var flamed = []

var draw_counter = 5
var bonus_draw_counter = 0
var head_draw_counter = 0

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
	"dm_4skulls": preload("res://resources/dominoes/special/dm_4_skull.tres"),
	"2_1_atk" : preload("res://resources/dominoes/start/dm_start_2_1_attack.tres"),
	"2_1_def" : preload("res://resources/dominoes/start/dm_start_2_1_defense.tres"),
	"3_1_atk" : preload("res://resources/dominoes/start/dm_start_3_1_attack.tres"),
	#"3_1_def" : preload("res://resources/dominoes/start/dm_start_3_1_defense.tres"),
	#"3_2_atk" : preload("res://resources/dominoes/start/dm_start_3_2_attack.tres"),
	#"3_2_def" : preload("res://resources/dominoes/start/dm_start_3_2_defense.tres"),
	#"4_2_atk_vulnerable": preload("res://resources/dominoes/start/dm_start_4_2_attack_vulnerable.tres"),
	"4_2_def_heal" : preload("res://resources/dominoes/start/dm_start_4_2_defense_heal.tres"),
}

@onready var domino_pool:= {
	"dm_4_1_attack_weak": preload("res://resources/dominoes/dm_4_1_attack_weak.tres"),
	"dm_3_3_attack2_corruption": preload("res://resources/dominoes/dm_3_3_attack2_corruption.tres"),
	"dm_2_1_fury": preload("res://resources/dominoes/dm_2_1_fury.tres"),
	"dm_4_3_attack2_heal": preload("res://resources/dominoes/dm_4_3_attack2_heal.tres"),
	"dm_4_2_defense_thorns": preload("res://resources/dominoes/dm_4_2_defense_thorns.tres"),
	"dm_2_2_thorns": preload("res://resources/dominoes/dm_2_2_thorns.tres"),
	"dm_2_1_defense_draw": preload("res://resources/dominoes/dm_2_1_defense_draw.tres"),
	"dm_3_2_heal": preload("res://resources/dominoes/dm_3_2_heal.tres"),
	"dm_3_2_corruption": preload("res://resources/dominoes/dm_3_2_corruption.tres"),
	"dm_3_2_corruption_weak": preload("res://resources/dominoes/dm_3_2_corruption_weak.tres"),
	"dm_4_1_attack_draw": preload("res://resources/dominoes/dm_4_1_attack_draw.tres"),
	
	"dm_spear": preload("res://resources/dominoes/special/dm_spear.tres"),
	"dm_steel_shield": preload("res://resources/dominoes/special/dm_steel_shield.tres"),
	"dm_corrupted_sphere": preload("res://resources/dominoes/special/dm_corrupted_sphere.tres"),
	"dm_claws": preload("res://resources/dominoes/special/dm_claws_2.tres"),
	"dm_dagger": preload("res://resources/dominoes/special/dm_dagger.tres"),
	"dm_defense_shield_strike": preload("res://resources/dominoes/special/dm_defense_shield_strike.tres"),
	"dm_hammer": preload("res://resources/dominoes/special/dm_hammer.tres"),
	"dm_mace": preload("res://resources/dominoes/special/dm_mace.tres"),
	"dm_corrupted_staff": preload("res://resources/dominoes/special/dm_corrupted_stuff.tres"),
	"dm_4skulls": preload("res://resources/dominoes/special/dm_4_skull.tres"),
	"dm_repeat": preload("res://resources/dominoes/special/dm_repeat.tres"),
	"dm_defense_crit": preload("res://resources/dominoes/special/dm_defense_crit.tres"),
	"dm_thorned_shield": preload("res://resources/dominoes/special/dm_thorned_shield.tres"),
	"dm_horn": preload("res://resources/dominoes/special/dm_horn.tres"),
}

#var temp_domino_pool 


func _ready() -> void:
	reset()
	Signals.reset_run_data.connect(reset)

func reset():
	#temp_domino_pool = domino_pool.duplicate()
	
	dominoes_on_board.clear()
	temp_deck.clear()
	deck.clear()
	discard.clear()
	
	Hand.dominoes.clear()
	for dm in Hand.get_children():
		dm.queue_free()
	
	set_deck()

func set_deck():
	var domino_scene = load("res://scenes/Dominoes/DominoTemplate/domino.tscn")
	for i in range(1): 
		for key in start_deck.keys():
			var domino: Domino 
			if start_deck[key] is DominoTemplate:
				domino = domino_scene.instantiate()
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
	discard.clear()
	
	# Перемешиваем колоду
	temp_deck.shuffle()


func reset_turn_data():
	pass
	
func reset_run_data():
	pass
