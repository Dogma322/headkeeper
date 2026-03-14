extends Node

var player_turn = true

var stage = 1

func _ready() -> void:
	Signals.play_btn_pressed.connect(play_dominoes)
	Signals.enemy_dead.connect(enemy_dead)
	#Signals.player_turn_begin.connect(player_turn_begin)
	#Signals.player_turn_end.connect(player_turn_end)
	#Signals.enemy_turn_begin.connect(enemy_turn_begin)
	#Signals.enemy_turn_end.connect(enemy_turn_end)
	
	await get_tree().create_timer(0.5).timeout
	player_turn_begin()



func play_dominoes():
	if Global.board_bonus_container.get_child_count() > 0:
		Global.board_bonus_container.add_bonus_actions()
		ActionManager.play_actions()
		await Signals.actions_completed
	
	
	for dm in DominoManager.dominoes_on_board:
			dm.add_actions()
	Signals.play_dominoes.emit()
	
	await Signals.actions_completed
	player_turn_end()
	
	
func player_turn_begin():
	BoardManager.generate_bonuses()
	await get_tree().create_timer(0.5).timeout
	Global.board.show_board()
	await get_tree().create_timer(0.6).timeout
	Hand.draw_dominoes()
	player_turn = true
	

func player_turn_end():
	Hand.discard_all_dominoes()
	Global.board.hide_board()
	await get_tree().create_timer(0.6).timeout
	
	if !Global.enemy.is_dead:
		enemy_turn_begin()
	
func enemy_turn_begin():
	player_turn = false
	
	apply_enemy_turn_begin_status_effects()
	await ActionManager.play_actions()
	
	Global.enemy.add_action()
	
	#print("ACT_SIZE")
	#print(ActionManager.queue.size())
	
	await get_tree().create_timer(0.5).timeout
	if Global.enemy.will_attack:
		Global.enemy.attack_animation()
		await Signals.enemy_attack
	
	ActionManager.play_actions()
	
	await Signals.actions_completed
	
	enemy_turn_end()
	
	
func apply_enemy_turn_begin_status_effects():
	for icon in Global.enemy.status_container.get_children():
		if icon.status.turn_begin_effect:
			icon.status.apply_status_effect()

	
func enemy_turn_end():
	Signals.enemy_turn_end.emit()
	player_turn_begin()
	
	
func enemy_dead():
	player_turn_end()
	await get_tree().create_timer(1).timeout
	show_rewards()
	
func show_rewards():
	show_domino_choice()
	await Signals.domino_selected
	await get_tree().create_timer(0.5).timeout
	
	if stage == 1 or stage == 4 or stage == 7:
		show_head_choice()
		await Signals.head_selected
		
	else:
		show_action_cards()
		await Signals.action_card_selected
		
	change_stage()
	
	
func show_domino_choice():
	pass
	
func show_head_choice():
	pass
	
func show_action_cards():
	ActionCardManager.generate_action_cards()
	
	
func change_stage():
	stage += 1
	

	
	
	
	
	
	
	
	
