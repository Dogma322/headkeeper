extends Node

var player_turn = true
var stage_changing := false

var turn = 0
var map_node: MapNode
var stage:
	get:
		if map_node == null:
			return 0
		return map_node.stage

enum Mode {
	NONE,
	BATTLE,
	BATTLE_ELITE,
	CHOOSE_ELITE_HEAD
}

var mode = Mode.NONE
var current_enemy_head: Head = null
var upgrade_head := false

func _ready() -> void:
	Signals.play_btn_pressed.connect(play_dominoes)
	Signals.enemy_dead.connect(enemy_dead)
	Signals.hero_dead.connect(hero_dead)
	Signals.enemy_head_choosen.connect(func(head: Head): current_enemy_head = head)


func start(_map_node: MapNode) -> void:
	mode = Mode.BATTLE
	map_node = _map_node
	
	await get_tree().process_frame
	EnemyManager.set_enemy(map_node)
	SoundManager.set_music(Global.enemy.location)
	SceneManager.background.set_battle_background()
	
	Transition.blackout_off()
	await get_tree().create_timer(1).timeout
	
	BoardManager.generate_board()
	
	player_turn_begin(true)


func change_stage(_map_node, _elite: bool) -> void:
	map_node = _map_node
	if _elite:
		mode = Mode.CHOOSE_ELITE_HEAD
	else:
		mode = Mode.BATTLE
	
	if stage_changing:
		return # уже меняется стадия, игнорируем повторный вызов
	stage_changing = true
	
	reset_fight_data()
	print("STAGE %d" % stage)
	reset_turn_data()
	
	BoardManager.generate_board()
	EnemyManager.set_enemy(map_node)
	SoundManager.set_music(Global.enemy.location)
	SceneManager.background.set_battle_background()
	Signals.stage_changed.emit()
	Transition.blackout_off()
	await get_tree().create_timer(1).timeout
	stage_changing = false
	player_turn_begin(false)


func play_dominoes() -> void:
	if DominoManager.dominoes_on_board.size() == 0:
		return
	
	print("PLAY_D")
	Global.fight_scene.hide_menu()
	
	DominoManager.block_domino_input = true
	
	if Global.board_bonus_container.get_child_count() > 0:
		Global.board_bonus_container.add_bonus_actions()
		ActionManager.play_actions()
		await Signals.actions_completed
	
	if Global.enemy.is_dead:
		return
	
	for dm in DominoManager.dominoes_on_board:
		if Global.hero.domino_ignore_count > 0:
			Global.hero.domino_ignore_count -= 1
			ActionManager.add(NothingAction.new(self, Global.hero, 0))
			continue
		dm.add_actions()
	Signals.play_dominoes.emit()
	
	await Signals.actions_completed
	
	if Global.enemy.is_dead:
		return
	player_turn_end()


func player_turn_begin(is_start: bool) -> void:
	print("P_BEGIN")
	Signals.player_turn_begin.emit()
	
	if mode == Mode.CHOOSE_ELITE_HEAD:
		Global.fight_scene.show_head_ui()
		await Signals.enemy_head_choosen
		mode = Mode.BATTLE_ELITE
	
	apply_hero_turn_begin_status_effects()
	await ActionManager.play_actions()
	
	turn += 1
	if turn == 1:
		add_hero_heads_battle_begin_actions()
		await ActionManager.play_actions()
		
		add_hero_heads_turn_begin_actions()
		await ActionManager.play_actions()
		
		Signals.fight_started.emit()
	else:
		add_hero_heads_turn_begin_actions()
		await ActionManager.play_actions()
	
	add_enemy_heads_turn_begin_actions()
	await ActionManager.play_actions()
	
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


func player_turn_end() -> void:
	print("P_END")
	
	Signals.player_turn_end.emit()
	
	for status_icon in Global.hero.status_container.get_children():
		status_icon.status.end_turn_reduce()
	
	Global.hand.discard_all_dominoes()
	Global.board.hide_board()
	await get_tree().create_timer(0.6).timeout
	
	if !Global.enemy.is_dead:
		enemy_turn_begin()


func enemy_turn_begin() -> void:
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


func add_hero_heads_battle_begin_actions() -> void:
	for head in Global.head_holder.get_children():
		if head is Head:
			head.battle_start_add_action()


func add_hero_heads_turn_begin_actions() -> void:
	for head in Global.head_holder.get_children():
		if head is Head:
			head.turn_begin_add_action()


func add_enemy_heads_turn_begin_actions() -> void:
	for head in Global.enemy_head_holder.get_children():
		if head is Head:
			head.turn_begin_add_action()


func enemy_turn_end():
	print("E_END")
	
	Signals.enemy_turn_end.emit()
	
	for status_icon in Global.enemy.status_container.get_children():
		status_icon.status.end_turn_reduce()
	
	if not Global.hero.is_dead:
		player_turn_begin(false)


func enemy_dead():
	print("E_DEAD")
	player_turn_end()
	DominoManager.reshuffle_discard_into_deck()
	await get_tree().create_timer(1).timeout
	show_rewards()


func show_rewards() -> void:
	DominoManager.block_domino_input = false
#	show_domino_choice()
	
	if Global.skulls_rewards.round_rewards.has(stage):
		Run.skulls += Global.skulls_rewards.round_rewards[stage]
	
	match map_node.type:
		MapNode.Type.BATTLE:
			Run.gold += randi_range(10, 20)
		MapNode.Type.BATTLE_ELITE:
			Run.gold += randi_range(25, 35)
			
			if current_enemy_head:
				current_enemy_head.get_parent().remove_child(current_enemy_head)
				if upgrade_head:
					Run.current_head_pool.insert(Run.last_removed_head_pos, current_enemy_head)
					Run.current_head_pool_keys.insert(Run.last_removed_head_pos, current_enemy_head.key)
					current_enemy_head.level += 1
				else:
					Run.current_head_pool.push_back(current_enemy_head)
					Run.current_head_pool_keys.push_back(current_enemy_head.key)
				Signals.head_amount_changed.emit()
				
				current_enemy_head.remove_passive_effect()
				current_enemy_head.invert_logic = false
				current_enemy_head.update_desc()
				
				Global.head_holder.add_child(current_enemy_head)
				if upgrade_head:
					Global.head_holder.move_child(current_enemy_head, Run.last_removed_head_pos + 1)
				current_enemy_head.apply_passive_effect()
				upgrade_head = false

	
#	await Signals.domino_selected
#	await get_tree().create_timer(1).timeout

	Global.fight_scene.hide_menu()
	await get_tree().create_timer(1.0).timeout
	
	SceneManager.main_scene = SceneManager.action_card_scene
	SceneManager.show_action_card_scene()
	ActionCardManager.show_battle_cards()
	
	#if stage == 1 or stage == 4 or stage == 7:
		#show_head_choice()
		#await Signals.head_selected
	#else:
		#show_action_cards()
		#await Signals.action_card_selected
		
	#await get_tree().create_timer(1).timeout
	#change_stage()


func show_domino_choice() -> void:
	Global.choice_scene.spawn_dominoes()


func show_head_choice() -> void:
	Global.choice_scene.spawn_heads()


func show_delete_domino_menu(amount: int) -> void:
	SceneManager.show_remove_domino_scene(amount)
	#change_stage() вызывается внутри Global.remove_domino_scene


func reset_turn_data() -> void:
	ActionManager.queue.clear()
	Signals.reset_turn_data.emit()
	clear_statuses()
	turn = 0


func reset_run_data() -> void:
	Signals.reset_run_data.emit()
	DominoManager.block_domino_input = false
	Global.map_scene.reset()
	Global.board.hide_board()
	
	stage = 1


func reset_fight_data() -> void:
	BoardManager.green_bonuses_activated = 0
	DominoManager.value1_played_dominoes = 0
	DominoManager.value2_played_dominoes = 0
	DominoManager.value3_played_dominoes = 0
	DominoManager.value4_played_dominoes = 0


func clear_statuses() -> void:
	for icon in Global.hero.status_container.get_children():
		StatusManager.remove_status_effect(icon.status)
		icon.queue_free()
	for icon in Global.enemy.status_container.get_children():
		StatusManager.remove_status_effect(icon.status)
		icon.queue_free()


func hero_dead() -> void:
	return_to_meta()


func return_to_meta() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	Transition.blackout_off()
	
	reset_run_data()
	Foreground.options_panel.show_box(Foreground.options_panel.meta_box)
	
	Global.map_scene.hide()
	Global.fight_scene.hide()
	
	Global.meta_scene.start()
	Global.meta_scene.show()
