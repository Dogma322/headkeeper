extends Node

var dominoes_on_board = []
var deck = []
var temp_deck = []
var discard = []
var flamed = []

var draw_counter = 5

var value1_played_dominoes = 0
var value2_played_dominoes = 0
var value3_played_dominoes = 0
var value4_played_dominoes = 0

var dm_dragging = false

@onready var start_deck := {
	#"4_2_atk_vulnerable": preload("res://scenes/Dominoes/StartDominoes/dm_start_4_2_vulnerable_attack.tscn"),
	"3_2_atk": preload("res://scenes/Dominoes/StartDominoes/dm_start_3_2_atck.tscn"),
	"3_2_def": preload("res://scenes/Dominoes/StartDominoes/dm_start_3_2_def.tscn"),
	"3_2_atk2": preload("res://scenes/Dominoes/StartDominoes/dm_start_3_2_atck.tscn"),
	"3_2_def2": preload("res://scenes/Dominoes/StartDominoes/dm_start_3_2_def.tscn"),
	"3_2_atk3": preload("res://scenes/Dominoes/StartDominoes/dm_start_3_2_atck.tscn"),
	"3_2_def3": preload("res://scenes/Dominoes/StartDominoes/dm_start_3_2_def.tscn"),
	"3_2_atk4": preload("res://scenes/Dominoes/StartDominoes/dm_start_3_2_atck.tscn"),
	"3_2_def4": preload("res://scenes/Dominoes/StartDominoes/dm_start_3_2_def.tscn"),
	"3_2_atk5": preload("res://scenes/Dominoes/StartDominoes/dm_start_3_2_atck.tscn"),
	"3_2_def5": preload("res://scenes/Dominoes/StartDominoes/dm_start_3_2_def.tscn"),

}


func _ready() -> void:
	set_deck()
	

	
	
func set_deck():
	temp_deck.clear()
	deck.clear()
	discard.clear()

	for i in range(1): 
		for key in start_deck.keys():
			var scene = start_deck[key]     
			 # достаём PackedScene
			var bone = scene.instantiate()   
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
	


		
	
