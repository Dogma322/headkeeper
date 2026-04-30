extends Node

var choose_domino = preload("res://scenes/ActionCards/ac_choose_domino.tscn")
var craft_domino = preload("res://scenes/ActionCards/ac_craft_domino.tscn")

var heal = preload("res://scenes/ActionCards/ac_heal.tscn")
var max_hp = preload("res://scenes/ActionCards/ac_max_hp.tscn")
var bonuses = preload("res://scenes/ActionCards/ac_bonuses.tscn")
var delete_dominoes = preload("res://scenes/ActionCards/ac_delete_dominoes.tscn")

var heal_bonus = preload("res://scenes/ActionCards/ac_heal_bonus.tscn")
var attack_bonus = preload("res://scenes/ActionCards/ac_attack_bonus.tscn")
var defense_bonus = preload("res://scenes/ActionCards/ac_defense_bonus.tscn")
var draw_bonus = preload("res://scenes/ActionCards/ac_draw_bonus.tscn")
var repeat_bonus = preload("res://scenes/ActionCards/ac_repeat_bonus.tscn")
var crit_bonus = preload("res://scenes/ActionCards/ac_crit_bonus.tscn")
var vulnerable_bonus = preload("res://scenes/ActionCards/ac_vulnerable_bonus.tscn")
var weak_bonus = preload("res://scenes/ActionCards/ac_weak_bonus.tscn")

var end_run = preload("res://scenes/ActionCards/ac_end_run.tscn")
var endless_mode = preload("res://scenes/ActionCards/ac_endless_mode.tscn")

var battle_stage_pool = [choose_domino, craft_domino]
var stage5_pool = [crit_bonus, draw_bonus]
var stage36_pool = [heal, bonuses]
var stage28_pool = [max_hp, delete_dominoes]
var stage9_pool = [heal, repeat_bonus]
var stage10_pool = [end_run, endless_mode]
var endless_mode_pool_with_bonus = [heal, max_hp, bonuses, delete_dominoes]
var endless_mode_pool_without_bonus = [heal, max_hp, delete_dominoes]

var action_card_is_pressed = false
var bonus_action_cards_pool = [heal_bonus, attack_bonus, defense_bonus, draw_bonus, 
vulnerable_bonus, weak_bonus]




var campfire_pool = [heal, max_hp]

func _ready() -> void:
	Signals.action_card_selected.connect(hide_cont)

func hide_cont():
	Global.action_card_container.hide_cont()

func show_cont():
	Global.action_card_container.show_cont()

func clear_cont():
	Global.action_card_container.clear_cont()


func show_action_cards(stage: int) -> void:
	clear_cont()
	add_action_cards(stage)
	show_cont()
	action_card_is_pressed = false

func show_battle_cards():
	show_action_cards_pool(battle_stage_pool)

func show_campfire_cards() -> void:
	show_action_cards_pool(campfire_pool)

func show_action_cards_pool(pool):
	var box = Global.action_card_container
	if pool == campfire_pool:
		return
	box.clear_cont()
	box.show()
	for card in pool:
		box.add_child(card.instantiate())
	box.show_cont()
	action_card_is_pressed = false


func add_action_cards(stage: int):
	var temp_pool = stage28_pool.duplicate()
	#if stage == 2:
	#	temp_pool = stage28_pool.duplicate()
		
	#if stage == 3:
		#temp_pool = stage36_pool.duplicate()
		#
	#if stage == 5:
		#temp_pool = stage5_pool.duplicate()
	#
	#if stage == 6:
		#temp_pool = stage36_pool.duplicate()
		#
	#if stage == 8:
		#temp_pool = stage28_pool.duplicate()
		#
	#if stage == 9:
		#temp_pool = stage9_pool.duplicate()
		#
	#if stage == 10:
		#temp_pool = stage10_pool.duplicate()
		
	#if stage > 10:
		#if BoardManager.bonus_pool.size() < 12:
			#temp_pool = ActionCardManager.endless_mode_pool_with_bonus.duplicate()
		#else:
			#temp_pool = ActionCardManager.endless_mode_pool_without_bonus.duplicate()
	
	#for card in temp_pool:
		#Global.action_card_container.add_child(card.instantiate())
		
	for i in range(temp_pool.size()):
		var card = temp_pool.pick_random()
		temp_pool.erase(card)
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
