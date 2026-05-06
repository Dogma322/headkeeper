extends Node

const MIN_POINTS = 1
const MAX_POINTS = 4

@export_group("Heads")
@export_subgroup("Berserk", "hd")

@export_range(MIN_POINTS, MAX_POINTS) var hd_berserk_activator_value := 3
@export var hd_berserk_damage_to_enemy := 3
@export var hd_berserk_damage_to_hero := 1
@export var hd_berserk_fury_level_2 := 1
@export var hd_berserk_fury_level_3 := 2

@export_subgroup("Rock", "hd")
@export var hd_rock_armor_per_action_to_hero_level_1 := 2
@export var hd_rock_armor_per_action_to_hero_level_2 := 3
@export var hd_rock_armor_per_action_to_hero_level_3 := 4
@export var hd_rock_armor_per_action_to_enemy := 1
@export var hd_rock_armor_level_2 := 15
@export var hd_rock_armor_level_3 := 45
@export var hd_rock_health_decrement := 15
