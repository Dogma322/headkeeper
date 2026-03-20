extends Node

var dominoes_on_board = []
var deck = []
var temp_deck = []
var discard = []
var flamed = []

var draw_counter = 5
var bonus_draw_counter = 0

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
	
	"3_2_atk": preload("res://scenes/Dominoes/StartDominoes/dm_start_3_2_atck.tscn"),
	"3_2_def": preload("res://scenes/Dominoes/StartDominoes/dm_start_3_2_def.tscn"),
	"2_1_atk": preload("res://scenes/Dominoes/StartDominoes/dm_start_2_1_attack.tscn"),
	"2_1_atk2": preload("res://scenes/Dominoes/StartDominoes/dm_start_2_1_attack.tscn"),
	"2_1_def": preload("res://scenes/Dominoes/StartDominoes/dm_start_2_1_defense.tscn"),
	"3_1_atk": preload("res://scenes/Dominoes/StartDominoes/dm_start_3_1_attack.tscn"),
	"3_1_def": preload("res://scenes/Dominoes/StartDominoes/dm_start_3_1_defense.tscn"),
	"3_1_def2": preload("res://scenes/Dominoes/StartDominoes/dm_start_3_1_defense.tscn"),
	"4_2_def_vulnerable": preload("res://scenes/Dominoes/StartDominoes/dm_start_4_2_vulnerable_attack.tscn"),
	"4_2_def_heal": preload("res://scenes/Dominoes/StartDominoes/dm_start_4_2_heal_defense.tscn"),
	
}

@onready var domino_pool:= {
	"4_1_attack_weak": preload("res://scenes/Dominoes/Dominoes/dm_4_1_attack_weak.tscn"),
	"dm_3_3_attack_corruption": preload("res://scenes/Dominoes/Dominoes/dm_3_3_attack_corruption.tscn"),
	"dm_2_1_fury": preload("res://scenes/Dominoes/Dominoes/dm_2_1_fury.tscn"),
	"dm_4_3_attack_heal": preload("res://scenes/Dominoes/Dominoes/dm_4_3_attack_heal.tscn"),
	"dm_4_2_def_thorns": preload("res://scenes/Dominoes/Dominoes/dm_4_2_def_thorns.tscn"),
	"dm_2_2_thorns": preload("res://scenes/Dominoes/Dominoes/dm_2_2_thorns.tscn"),
	"dm_2_1_defense_draw": preload("res://scenes/Dominoes/Dominoes/dm_2_1_defense_draw.tscn"),
	"dm_3_2_heal": preload("res://scenes/Dominoes/Dominoes/dm_3_2_heal.tscn"),
	"dm_3_2_corruption": preload("res://scenes/Dominoes/Dominoes/dm_3_2_corruption.tscn"),
	"dm_3_2_corruption_weak": preload("res://scenes/Dominoes/Dominoes/dm_3_2_corruption_weak.tscn"),
	"dm_4_1_attack_draw": preload("res://scenes/Dominoes/Dominoes/dm_4_1_attack_draw.tscn"),
	
	"dm_spear": preload("res://scenes/Dominoes/Dominoes/dm_spear.tscn"),
	"dm_steel_shield": preload("res://scenes/Dominoes/Dominoes/dm_shield.tscn"),
	"dm_corrupted_sphere": preload("res://scenes/Dominoes/Dominoes/dm_corrupted_sphere.tscn"),
	"dm_claws": preload("res://scenes/Dominoes/Dominoes/dm_claws.tscn"),
	"dm_dagger": preload("res://scenes/Dominoes/Dominoes/dm_dagger.tscn"),
	"dm_shield_strike": preload("res://scenes/Dominoes/Dominoes/dm_shield_strike.tscn"),
	"dm_hammer": preload("res://scenes/Dominoes/Dominoes/dm_hammer.tscn"),
	"dm_mace": preload("res://scenes/Dominoes/Dominoes/dm_mace.tscn"),
	"dm_corrupted_staff": preload("res://scenes/Dominoes/Dominoes/dm_corrupted_stuff.tscn"),
	"dm_4skulls": preload("res://scenes/Dominoes/Dominoes/dm_4_skulls.tscn"),
	"dm_repeat": preload("res://scenes/Dominoes/Dominoes/dm_repeat.tscn"),
	"dm_defense_crit": preload("res://scenes/Dominoes/Dominoes/dm_defense_crit.tscn"),
	"dm_thorned_shield": preload("res://scenes/Dominoes/Dominoes/dm_thorned_shield.tscn"),
	"dm_horn": preload("res://scenes/Dominoes/Dominoes/dm_horn.tscn"),
	
	
	
	
	
	

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
	for i in range(1): 
		for key in start_deck.keys():
			var scene = start_deck[key]     
			 # достаём PackedScene
			var bone = scene.instantiate()   
			bone.global_position.y = -100000 # HACK: чтобы не было краша игры при наведении на край экрана.
			add_child(bone)
			deck.append(bone)
		
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
	
