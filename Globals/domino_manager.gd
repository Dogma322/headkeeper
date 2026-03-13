extends Node

var dominoes_on_board = []
var deck = []
var temp_deck = []
var discard = []
var flamed = []

var draw_counter = 5

@onready var start_deck := {
	"3_2_atk1": preload("res://scenes/Dominoes/DominoTemplate/domino_template.tscn"),
	"3_2_atk2": preload("res://scenes/Dominoes/DominoTemplate/domino_template.tscn"),
	"3_2_atk3": preload("res://scenes/Dominoes/DominoTemplate/domino_template.tscn"),
	"3_2_atk4": preload("res://scenes/Dominoes/DominoTemplate/domino_template.tscn"),
	"3_2_atk5": preload("res://scenes/Dominoes/DominoTemplate/domino_template.tscn"),
	"3_2_atk6": preload("res://scenes/Dominoes/DominoTemplate/domino_template.tscn"),
	"3_2_atk7": preload("res://scenes/Dominoes/DominoTemplate/domino_template.tscn"),
	"3_2_atk8": preload("res://scenes/Dominoes/DominoTemplate/domino_template.tscn"),
	"3_2_atk9": preload("res://scenes/Dominoes/DominoTemplate/domino_template.tscn"),
	"3_2_atk10": preload("res://scenes/Dominoes/DominoTemplate/domino_template.tscn"),
	"3_2_atk11": preload("res://scenes/Dominoes/DominoTemplate/domino_template.tscn"),
	"3_2_atk12": preload("res://scenes/Dominoes/DominoTemplate/domino_template.tscn"),
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
	


		
	
