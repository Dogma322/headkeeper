extends Node

var player_turn = true



func _ready() -> void:
	Signals.play_btn_pressed.connect(play_dominoes)
	Signals.player_turn_begin.connect(player_turn_begin)
	Signals.player_turn_end.connect(player_turn_end)
	Signals.enemy_turn_begin.connect(enemy_turn_begin)
	Signals.enemy_turn_end.connect(enemy_turn_end)
	
	await get_tree().create_timer(0.5).timeout
	player_turn_begin()



func play_dominoes():
	
	Global.board_bonus_container.add_bonus_actions()
	ActionManager.play_actions()
	await Signals.actions_completed
	
	
	for dm in DominoManager.dominoes_on_board:
			dm.add_action()
	Signals.play_dominoes.emit()
	
	await Signals.actions_completed
	Hand.discard_all_dominoes()
	Global.board.hide_board()
	await get_tree().create_timer(0.6).timeout
	player_turn_end()
	
	
func player_turn_begin():
	BoardManager.generate_bonuses()
	await get_tree().create_timer(0.5).timeout
	Global.board.show_board()
	await get_tree().create_timer(0.6).timeout
	Hand.draw_dominoes()
	player_turn = true
	

func player_turn_end():
	enemy_turn_begin()
	
func enemy_turn_begin():
	player_turn = false
	
	Global.enemy.add_action()
	
	await get_tree().create_timer(0.5).timeout
	if Global.enemy.will_attack:
		Global.enemy.attack_animation()
		await Signals.enemy_attack
	
	ActionManager.play_actions()
	
	await Signals.actions_completed
	
	enemy_turn_end()
	
func enemy_turn_end():
	player_turn_begin()
