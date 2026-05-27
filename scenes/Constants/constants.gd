extends Node

const MIN_POINTS = 1
const MAX_POINTS = 4

@export_group("Heads")

@export_subgroup("Berserk", "hd_berserk")
@export_range(MIN_POINTS, MAX_POINTS) var hd_berserk_activator_value := 3
@export var hd_berserk_damage_to_enemy := 3
@export var hd_berserk_damage_to_hero := 1
@export var hd_berserk_fury_level_2 := 1
@export var hd_berserk_fury_level_3 := 2

@export_subgroup("Rock", "hd_rock")
@export var hd_rock_armor_per_action_to_hero_level_1 := 2
@export var hd_rock_armor_per_action_to_hero_level_2 := 3
@export var hd_rock_armor_per_action_to_hero_level_3 := 4
@export var hd_rock_armor_per_action_to_enemy := 1
@export var hd_rock_armor_level_2 := 15
@export var hd_rock_armor_level_3 := 45
@export var hd_rock_health_decrement := 15

@export_subgroup("Chaos", "hd_chaos")
@export var hd_chaos_damage_level_1 := 4
@export var hd_chaos_damage_level_2 := 5
@export var hd_chaos_damage_level_3 := 6
@export var hd_chaos_damage_to_hero := 2

@export_subgroup("Druid", "hd_druid")
@export var hd_druid_fury_level_1 := 2
@export var hd_druid_fury_level_2 := 2
@export var hd_druid_fury_level_3 := 4
@export var hd_druid_crit_level_2 := 1
@export var hd_druid_crit_level_3 := 1
@export var hd_druid_fury_to_enemy := 1
@export var hd_druid_health_decrement := 20

@export_subgroup("Thorn", "hd_thorn")
@export var hd_thorn_thorns_to_hero := 4
@export var hd_thorn_thorns_to_enemy := 2

@export_subgroup("Moon", "hd_moon")
@export var hd_moon_domino_activator_value := 8
@export var hd_moon_damage_level_1 := 12
@export var hd_moon_damage_level_2 := 12
@export var hd_moon_damage_level_3 := 16
@export var hd_moon_armor_level_2 := 12
@export var hd_moon_armor_level_3 := 16
@export var hd_moon_draw_level_3 := 1
@export var hd_moon_damage_to_hero := 8

@export_subgroup("False King", "hd_false_king")
@export var hd_false_king_health_decrement := 45
@export var hd_false_king_gold_level_2 = 150
@export var hd_false_king_gold_level_3 = 300

@export_subgroup("Corruptor", "hd_corruptor")
@export var hd_corruptor_corruption_level_1 := 2
@export var hd_corruptor_corruption_level_2 := 3
@export var hd_corruptor_corruption_level_3 := 4
@export var hd_corruptor_damage_level_2 := 4
@export var hd_corruptor_damage_level_3 := 6
@export var hd_corruptor_corruption_to_hero := 3

@export_subgroup("Phantom", "hd_phantom")
@export var hd_phantom_damage_level_1 := 3
@export var hd_phantom_damage_level_2 := 5
@export var hd_phantom_damage_level_3 := 7
@export var hd_phantom_damage_to_hero := 1

@export_subgroup("Apostle", "hd_apostle")
@export var hd_apostle_corruption_level_1 := 3
@export var hd_apostle_corruption_level_2 := 4
@export var hd_apostle_corruption_level_3 := 5
@export var hd_apostle_weak_level_2 := 1
@export var hd_apostle_weak_level_3 := 1
@export var hd_apostle_vulnerable_level_3 := 1
@export var hd_apostle_corruption_to_hero := 1
@export var hd_apostle_health_decrement := 20

@export_subgroup("White Thorn", "hd_white_thorn")
@export var hd_white_thorn_startup_thorns_level_3 := 6

@export_subgroup("Construct", "hd_construct")
@export var hd_construct_block_level_1 := 5
@export var hd_construct_block_level_2 := 7
@export var hd_construct_block_level_3 := 9
@export var hd_construct_thorns_level_2 := 2
@export var hd_construct_thorns_level_3 := 4
@export var hd_construct_block_to_enemy := 5

@export_subgroup("Warden", "hd_warden")
@export var hd_warden_max_hp_increment_level_1 := 30
@export var hd_warden_max_hp_increment_level_2 := 45
@export var hd_warden_max_hp_increment_level_3 := 70
@export var hd_warden_regen_level_2 := 4
@export var hd_warden_regen_level_3 := 8

@export_subgroup("Maw", "hd_maw")
@export var hd_maw_fury_level_2 := 4
@export var hd_maw_fury_level_3 := 8
@export var hd_maw_fury_to_enemy := 3
@export var hd_maw_health_decrement := 35
