extends Node

@warning_ignore_start("unused_signal")

signal play_btn_pressed
signal play_dominoes
signal projectile_hit
signal enemy_dead
signal hero_dead

signal player_turn_begin
signal player_turn_end
signal enemy_turn_begin
signal enemy_turn_end

signal actions_completed
signal enemy_attack

signal deck_changed
signal discard_changed

signal domino_played
signal green_bonus_played
signal red_bonus_played
signal yellow_bonus_played

signal domino_selected
signal head_selected
signal action_card_selected
signal domino_deleted_from_deck
signal domino_delete_completed
signal domino_added_to_board(domino: Domino)
signal domino_chain_removed

signal _1dm_played(domino)
signal _2dm_played(domino)
signal _3dm_played(domino)
signal _4dm_played(domino)

signal attack_dm_played(domino: Domino)
signal defense_dm_played(domino: Domino)
signal skill_dm_played(domino: Domino)

signal enemy_take_damage
signal hero_take_damage

signal deal_enemy_thorn_damage
signal deal_hero_thorn_damage

signal reset_turn_data
signal reset_run_data

signal fight_started

signal hero_healed

signal stage_changed

signal money_changed(money: int)

signal play_domino_added_to_slot_sound
signal play_domino_draged_sound
signal play_domino_play_sound
signal play_discard_all_dominoes_sound
signal play_action_card_sound

signal play_block_sound
signal play_damage_sound
signal play_heal_sound
signal play_status_sound
