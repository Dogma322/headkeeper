extends Node

var player_turn = true
var stage_changing := false

var turn = 0
var stage = 1
var map_node: MapNode


func _ready() -> void:
	Signals.play_btn_pressed.connect(play_dominoes)
	Signals.enemy_dead.connect(enemy_dead)
	Signals.hero_dead.connect(hero_dead)
	
	

	
func start(_map_node: MapNode):
	map_node = _map_node
	
	await get_tree().process_frame
	EnemyManager.set_enemy(map_node)
	SoundManager.set_music(Global.enemy.location)
	Global.background.set_battle_background()
	
	Transition.blackout_off()
	await get_tree().create_timer(1).timeout
	
	BoardManager.generate_board()
	
	player_turn_begin(true)

func change_stage(_map_node):
	map_node = _map_node
	
	if stage_changing:
		return # уже меняется стадия, игнорируем повторный вызов
	stage_changing = true
	
	reset_fight_data()
	stage += 1
	print("STAGE %d" % stage)
	print(stage)
	reset_turn_data()
	BoardManager.generate_board()
	EnemyManager.set_enemy(map_node)
	SoundManager.set_music(Global.enemy.location)
	Global.background.set_battle_background()
	Signals.stage_changed.emit()
	Transition.blackout_off()
	await get_tree().create_timer(1).timeout
	stage_changing = false
	player_turn_begin(false)
	

func play_dominoes():
	print("PLAY_D")
	
	Global.fight_scene.hide_menu()
	
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
	
	
func player_turn_begin(is_start: bool):
	print("P_BEGIN")
	Signals.player_turn_begin.emit()
	
	apply_hero_turn_begin_status_effects()
	await ActionManager.play_actions()
	if is_start and stage == 1:
		if not MetaManager.selected_head_key.is_empty():
			HeadManager.temp_head_pool.erase(MetaManager.selected_head_key)
			
			var head = HeadManager.head_pool[MetaManager.selected_head_key].instantiate()
			head.add_head_to_head_holder()
	
	add_heads_turn_begin_actions()
	await ActionManager.play_actions()
	
	
	turn += 1
	if turn == 1:
		Signals.fight_started.emit()
		


	await get_tree().create_timer(0.5).timeout
	
	if ActionManager.queue.size() > 0:
		ActionManager.play_actions()
		await Signals.actions_completed
	
	
	BoardManager.generate_bonuses()
	await get_tree().create_timer(0.2).timeout
	Global.board.show_board()
	Global.fight_scene.show_menu()
	await get_tree().create_timer(0.6).timeout
	Global.hand.draw_dominoes()
	player_turn = true
	DominoManager.block_domino_input = false
	

func player_turn_end():
	print("P_END")
	
	Signals.player_turn_end.emit()
	
	for status_icon in Global.hero.status_container.get_children():
		status_icon.status.end_turn_reduce()
	
	
	Global.hand.discard_all_dominoes()
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
	
	if Global.enemy.is_dead:
		return 
	
	enemy_turn_end()
	
	
func apply_enemy_turn_begin_status_effects():
	for icon in Global.enemy.status_container.get_children():
		if icon.status.turn_begin_effect:
			StatusManager.apply_status_effect(icon.status)
			
func apply_hero_turn_begin_status_effects():
	for icon in Global.hero.status_container.get_children():
		if icon.status.turn_begin_effect:
			StatusManager.apply_status_effect(icon.status)

func add_heads_turn_begin_actions():
	for head in Global.head_holder.get_children():
		head.turn_begin_add_action()

	
func enemy_turn_end():
	print("E_END")
	
	Signals.enemy_turn_end.emit()
	
	for status_icon in Global.enemy.status_container.get_children():
		status_icon.status.end_turn_reduce()
	
	player_turn_begin(false)
	
	
func enemy_dead():
	print("E_DEAD")
	player_turn_end()
	DominoManager.reshuffle_discard_into_deck()
	await get_tree().create_timer(1).timeout
	show_rewards()

func show_rewards():
	DominoManager.block_domino_input = false
#	show_domino_choice()
	
	if MoneyManager.money_rewards.round_rewards.has(stage):
		MoneyManager.money += MoneyManager.money_rewards.round_rewards[stage]
	
#	await Signals.domino_selected
#	await get_tree().create_timer(1).timeout

	Global.fight_scene.hide_menu()
	
	Transition.blackout_on()
	await get_tree().create_timer(1.0).timeout
	Transition.blackout_off()
	SceneManager.show_map_scene()
	
	#if stage == 1 or stage == 4 or stage == 7:
		#show_head_choice()
		#await Signals.head_selected
	#else:
		#show_action_cards()
		#await Signals.action_card_selected
		
	#await get_tree().create_timer(1).timeout
	#change_stage()
	
	
func show_domino_choice():
	Global.choice_scene.spawn_dominoes()
	
func show_head_choice():
	Global.choice_scene.spawn_heads()
	
func show_action_cards():
	ActionCardManager.show_action_cards()

func show_common_cards():
	ActionCardManager.show_action_cards(true)

func show_delete_domino_menu():
	await get_tree().create_timer(1).timeout
	Global.remove_domino_scene.update_domino_list()
	#change_stage() вызывается внутри Global.remove_domino_scene


	
func reset_turn_data():
	ActionManager.queue.clear()
	Signals.reset_turn_data.emit()
	clear_statuses()
	turn = 0
	
func reset_run_data():
	Signals.reset_run_data.emit()
	DominoManager.block_domino_input = false
	Global.map_scene.reset()
	
	stage = 1
	
func reset_fight_data():
	BoardManager.green_bonuses_activated = 0
	DominoManager.value1_played_dominoes = 0
	DominoManager.value2_played_dominoes = 0
	DominoManager.value3_played_dominoes = 0
	DominoManager.value4_played_dominoes = 0
	
func clear_statuses():
	for icon in Global.hero.status_container.get_children():
		icon.status.stacks = 0
	
func hero_dead():
	return_to_main_menu()
	
func return_to_main_menu():
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	reset_run_data()
	
	get_tree().change_scene_to_file("res://scenes/MainScenes/main_menu.tscn")
	
	
