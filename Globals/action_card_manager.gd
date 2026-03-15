extends Node

var heal = preload("res://scenes/ActionCards/ac_heal.tscn")
var max_hp = preload("res://scenes/ActionCards/ac_max_hp.tscn")
var bonuses = preload("res://scenes/ActionCards/ac_bonuses.tscn")

var pool1 = [bonuses, max_hp]

var action_card_is_pressed = false
var bonus_action_cards_pool = [heal,heal,heal]

func _ready() -> void:
	Signals.action_card_selected.connect(hide_cont)

func hide_cont():
	Global.action_card_container.hide_cont()

func show_cont():
	Global.action_card_container.show_cont()

func clear_cont():
	Global.action_card_container.clear_cont()


func show_action_cards():
	clear_cont()
	add_action_cards()
	show_cont()
	action_card_is_pressed = false



func add_action_cards():
	var pool = pool1
	
	if CombatManager.stage == 1 or CombatManager.stage == 3:
		pool = pool1
		
	for card in pool:
		Global.action_card_container.add_child(card.instantiate())
		
	
func show_bonus_action_cards():
	hide_cont()
	await get_tree().create_timer(1).timeout
	action_card_is_pressed = false
	clear_cont()
	add_bonus_action_cards()
	show_cont()
	
func add_bonus_action_cards():
	var temp_pool = bonus_action_cards_pool.duplicate()
	
	for i in range(3):
		var card = temp_pool.pick_random()
		Global.action_card_container.add_child(card.instantiate())
		temp_pool.erase(card)
		
	

		
	
