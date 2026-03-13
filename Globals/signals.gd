extends Node

signal play_btn_pressed
signal play_dominoes
signal projectile_hit
signal enemy_dead

signal player_turn_begin
signal player_turn_end
signal enemy_turn_begin
signal enemy_turn_end

signal actions_completed
signal enemy_attack

signal deck_changed
signal discard_changed

signal domino_selected
signal head_selected

signal _1dm_played(domino)
signal _2dm_played(domino)
signal _3dm_played(domino)
signal _4dm_played(domino)

signal attack_dm_played(domino: Domino)
signal defense_dm_played(domino: Domino)
signal skill_dm_played(domino: Domino)
