extends Node

#@onready var tutorial_mushman = preload("res://scenes/Enemies/MushroomCaves/enm_tutorial_mushman.tscn")
#@onready var wolf1 = preload("res://scenes/Enemies/Forest/enm_wolf_1.tscn")
#@onready var high_druid = preload("res://scenes/Enemies/Forest/enm_high_druid.tscn")

@onready var early_enemy_pool: = {
		"armored_mush": preload("res://scenes/Enemies/MushCaves/enm_armored_mush.tscn"),
	
	
	#"mushman1": preload("res://scenes/Enemies/MushroomCaves/end_mushroomman_1.tscn"),
	#"young_witch1": preload("res://scenes/Enemies/Swamp/enm_young_witch_1.tscn"),
	#"cultist1": preload("res://scenes/Enemies/Forest/enm_cultist_1.tscn"),
	#"dark_witch1": preload("res://scenes/Enemies/Swamp/enm_dark_witch.tscn"),
	#"mush_warrior": preload("res://scenes/Enemies/MushroomCaves/enm_mush_warrior.tscn"),
	#"mother_mush": preload("res://scenes/Enemies/MushroomCaves/enm_mush_mother.tscn"),
}

@onready var mid_enemy_pool: = {
	"armored_mush": preload("res://scenes/Enemies/MushCaves/enm_armored_mush.tscn"),
	
	#"armored_mush": preload("res://scenes/Enemies/MushroomCaves/enm_armored_mush.tscn"),
	#"elder_witch": preload("res://scenes/Enemies/Swamp/enm_elder_witch.tscn"),
	#"deer2": preload("res://scenes/Enemies/Forest/enm_deer2.tscn"),
	#"cultist2": preload("res://scenes/Enemies/Forest/enm_cultist_2.tscn"),
	#"horned_witch2": preload("res://scenes/Enemies/Swamp/enm_horned_witch_2.tscn"),
	#"turret": preload("res://scenes/Enemies/MushroomCaves/enm_turret.tscn"),
	#"dark_witch2": preload("res://scenes/Enemies/Swamp/enm_dark_witch_2.tscn"),
	#"mother_mush2": preload("res://scenes/Enemies/MushroomCaves/enm_mush_mother_2.tscn"),
	#"shadow": preload("res://scenes/Enemies/Swamp/enm_shadow.tscn"),
}

@onready var late_enemy_pool: = {
	"armored_mush": preload("res://scenes/Enemies/MushCaves/enm_armored_mush.tscn"),
	
	
	#"crowwoman": preload("res://scenes/Enemies/Forest/enm_crowwoman.tscn"),
	#"wolf2": preload("res://scenes/Enemies/Forest/enm_wolf_2.tscn"),
	#"obsessed_witch": preload("res://scenes/Enemies/Swamp/enm_obsessed_witch.tscn"),
	#"shadow_goat": preload("res://scenes/Enemies/Swamp/enm_goat_shadow.tscn"),
	#"bear": preload("res://scenes/Enemies/Forest/enm_bear.tscn"),
	#"king": preload("res://scenes/Enemies/MushroomCaves/enm_king.tscn"),
}

	
@onready var endless_mode_pool: = {
	"armored_mush": preload("res://scenes/Enemies/MushCaves/enm_armored_mush.tscn"),
	
	#"void_warrior": preload("res://scenes/Enemies/EndlessMode/enm_void_warrior_1.tscn"),
	#"void_wisp1": preload("res://scenes/Enemies/EndlessMode/enm_void_wisp_1.tscn"),
	#"void_wisp2": preload("res://scenes/Enemies/EndlessMode/enm_void_wisp_2.tscn"),
	#"endless_wolf": preload("res://scenes/Enemies/EndlessMode/enm_endless_wolf.tscn"),
	#"endless_turret": preload("res://scenes/Enemies/EndlessMode/enm_endless_turret.tscn"),
	#"endless_young_witch": preload("res://scenes/Enemies/EndlessMode/endless_young_witch.tscn")
}

@onready var temp_early_enemy_pool = early_enemy_pool.duplicate()
@onready var temp_mid_enemy_pool = mid_enemy_pool.duplicate()
@onready var temp_late_enemy_pool = late_enemy_pool.duplicate()

func reset_enemy_pools():
	temp_early_enemy_pool = early_enemy_pool.duplicate()
	temp_mid_enemy_pool = mid_enemy_pool.duplicate()
	temp_late_enemy_pool = late_enemy_pool.duplicate()
