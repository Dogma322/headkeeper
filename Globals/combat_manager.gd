extends Node

var player_turn = true

var turn = 0
var stage = 1



func _ready() -> void:
	
	await get_tree().process_frame
	
	Transition.blackout_off()
	
	Signals.play_btn_pressed.connect(play_dominoes)
	Signals.enemy_dead.connect(enemy_dead)
	
	
	
	await get_tree().create_timer(0.5).timeout
	player_turn_begin()



func play_dominoes():
	print("PLAY_D")
	
	Global.play_btn.hide_btn()
	
	if DominoManager.dominoes_on_board.size() == 0:
		return
	
	DominoManager.block_domino_input = true
	
	if Global.board_bonus_container.get_child_count() > 0:
		Global.board_bonus_container.add_bonus_actions()
		ActionManager.play_actions()
		await Signals.actions_completed
	
	if Global.enemy.is_dead:
		return
	
	
	for dm in DominoManager.dominoes_on_board:
			dm.add_actions()
	Signals.play_dominoes.emit()
	
	await Signals.actions_completed
	
	if Global.enemy.is_dead:
		return
	player_turn_end()
	
	
func player_turn_begin():
	print("P_BEGIN")
	Signals.player_turn_begin.emit()
	
	apply_hero_turn_begin_status_effects()
	await ActionManager.play_actions()
	
	
	turn += 1
	if turn == 1:
		Signals.fight_started.emit()
		
	Signals.player_turn_begin.emit()


	await get_tree().create_timer(0.5).timeout
	
	if ActionManager.queue.size() > 0:
		ActionManager.play_actions()
		await Signals.actions_completed
	
	
	BoardManager.generate_bonuses()
	await get_tree().create_timer(0.2).timeout
	Global.board.show_board()
	Global.play_btn.show_btn()
	await get_tree().create_timer(0.6).timeout
	Hand.draw_dominoes()
	player_turn = true
	DominoManager.block_domino_input = false
	

func player_turn_end():
	print("P_END")
	
	Signals.player_turn_end.emit()
	
	for status_icon in Global.hero.status_container.get_children():
		status_icon.status.end_turn_reduce()
	
	
	Hand.discard_all_dominoes()
	Global.board.hide_board()
	await get_tree().create_timer(0.6).timeout
	
	if !Global.enemy.is_dead:
		enemy_turn_begin()
	
func enemy_turn_begin():
	await get_tree().create_timer(0.5).timeout
	Signals.enemy_turn_begin.emit()
	
	print("E_BEGIN")
	player_turn = false
	
	apply_enemy_turn_begin_status_effects()
	await ActionManager.play_actions()
	
	if Global.enemy.is_dead:
		return  
	
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
			
func apply_hero_turn_begin_status_effects():
	for icon in Global.hero.status_container.get_children():
		if icon.status.turn_begin_effect:
			icon.status.apply_status_effect()

	
func enemy_turn_end():
	print("E_END")
	
	Signals.enemy_turn_end.emit()
	
	for status_icon in Global.enemy.status_container.get_children():
		status_icon.status.end_turn_reduce()
	
	player_turn_begin()
	
	
func enemy_dead():
	print("E_DEAD")
	player_turn_end()
	DominoManager.reshuffle_discard_into_deck()
	await get_tree().create_timer(1).timeout
	show_rewards()
	
func show_rewards():
	DominoManager.block_domino_input = false
	show_domino_choice()
	await Signals.domino_selected
	await get_tree().create_timer(1).timeout
	
	if stage == 1 or stage == 4 or stage == 7:
		show_head_choice()
		await Signals.head_selected
	else:
		show_action_cards()
		await Signals.action_card_selected
		
	await get_tree().create_timer(1).timeout
	
	
	change_stage()
	
	
func show_domino_choice():
	Global.choice_scene.spawn_dominoes()
	
func show_head_choice():
	Global.choice_scene.spawn_heads()
	
func show_action_cards():
	ActionCardManager.show_action_cards()
	
func show_delete_domino_menu():
	await get_tree().create_timer(1).timeout
	Global.remove_domino_scene.update_domino_list()
	#change_stage() вызывается внутри Global.remove_domino_scene
	
	
func change_stage():
	
	stage += 1
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	reset_turn_data()
	EnemyManager.set_enemy()
	Global.fight_background.set_background()
	Transition.blackout_off()
	await get_tree().create_timer(1).timeout
	player_turn_begin()
	

	
func reset_turn_data():
	ActionManager.queue.clear()
	Signals.reset_turn_data.emit()
	clear_statuses()
	turn = 0
	
func reset_run_data():
	Signals.reset_run_data.emit()
	
	stage = 1
	
func clear_statuses():
	for icon in Global.hero.status_container.get_children():
		icon.status.stacks = 0
	
	
	
	
