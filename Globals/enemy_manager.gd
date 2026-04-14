extends Node

var pos = Vector2(530,168)

@onready var wolf1 = preload("res://scenes/Enemies/Swamp/enm_shadow.tscn")#, preload("res://scenes/Enemies/Forest/enm_wolf_1.tscn")
@onready var high_druid = preload("res://scenes/Enemies/Forest/enm_high_druid.tscn")

#@onready var tutorial_mushman = preload("res://scenes/Enemies/MushroomCaves/enm_tutorial_mushman.tscn")
#@onready var wolf1 = preload("res://scenes/Enemies/Forest/enm_wolf_1.tscn")
#@onready var high_druid = preload("res://scenes/Enemies/Forest/enm_high_druid.tscn")

@onready var early_enemy_pool: = {

	"mushman2": preload("res://scenes/Enemies/MushCaves/enm_mushman_1.tscn"),
	"young_witch": preload("res://scenes/Enemies/Swamp/enm_young_witch_1.tscn"),
	"cultist1": preload("res://scenes/Enemies/Forest/enm_cultist_1.tscn"),
	"dark_witch": preload("res://scenes/Enemies/Swamp/enm_dark_witch_1.tscn"),
	"mush_warrior": preload("res://scenes/Enemies/MushCaves/enm_mush_warrior.tscn"),
	"mother_mush": preload("res://scenes/Enemies/MushCaves/enm_mother_mush.tscn")
	
}

@onready var mid_enemy_pool: = {
	"armored_mush2": preload("res://scenes/Enemies/MushCaves/enm_armored_mush.tscn"),
	"cultist2": preload("res://scenes/Enemies/Forest/enm_cultist_2.tscn"),
	"dark_witch2": preload("res://scenes/Enemies/Swamp/enm_dark_witch_2.tscn"),
	"mother_mush2": preload("res://scenes/Enemies/MushCaves/enm_mother_mus_2.tscn"),
	"deer2": preload("res://scenes/Enemies/Forest/enm_deer_2.tscn"),
	"elder_witch": preload("res://scenes/Enemies/Swamp/enm_elder_witch.tscn"),
	"horned_witch": preload("res://scenes/Enemies/Swamp/enm_horned_witch_2.tscn"),
	"turret": preload("res://scenes/Enemies/MushCaves/enm_turret.tscn"),
	"shadow": preload("res://scenes/Enemies/Swamp/enm_shadow.tscn")
	
}

@onready var late_enemy_pool: = {
	"crowwoman": preload("res://scenes/Enemies/Forest/enm_crowwoman.tscn"),
	"wolf2": preload("res://scenes/Enemies/Forest/enm_wolf_2.tscn"),
	"shadow_goat": preload("res://scenes/Enemies/Swamp/enm_shadow_goat.tscn"),
	"bear": preload("res://scenes/Enemies/Forest/enm_bear.tscn"),
	"king": preload("res://scenes/Enemies/MushCaves/enm_king.tscn")
	
	

}

	
@onready var endless_mode_pool: = {
	"void_warriror": preload("res://scenes/Enemies/EndlessMode/enm_void_warrior_1.tscn"),
	"void_wisp1": preload("res://scenes/Enemies/EndlessMode/enm_void_wisp_1.tscn"),
	"void_wisp2": preload("res://scenes/Enemies/EndlessMode/enm_void_wisp_2.tscn"),
	"endless_wolf": preload("res://scenes/Enemies/EndlessMode/enm_endless_wolf.tscn"),
	"endless_turret": preload("res://scenes/Enemies/EndlessMode/enm_endless_turret.tscn"),
	"endless_young_witch": preload("res://scenes/Enemies/EndlessMode/enm_endless_young_witch.tscn")
	
}

@onready var temp_early_enemy_pool = early_enemy_pool.duplicate()
@onready var temp_mid_enemy_pool = mid_enemy_pool.duplicate()
@onready var temp_late_enemy_pool = late_enemy_pool.duplicate()

func _ready():
	Signals.reset_run_data.connect(reset_enemy_pools)


func reset_enemy_pools():
	temp_early_enemy_pool = early_enemy_pool.duplicate()
	temp_mid_enemy_pool = mid_enemy_pool.duplicate()
	temp_late_enemy_pool = late_enemy_pool.duplicate()
	
func set_enemy():
	if Global.enemy:
		Global.enemy.queue_free()
		
	var new_enemy
		
	if CombatManager.stage == 0:
		new_enemy = wolf1.instantiate()
		
	if CombatManager.stage == 1:
		new_enemy = wolf1.instantiate()
		
	if CombatManager.stage > 1 and CombatManager.stage < 4:
		var keys =  temp_early_enemy_pool.keys()
		var random_key = keys.pick_random()
		var enemy = temp_early_enemy_pool[random_key]

		EnemyManager.temp_early_enemy_pool.erase(random_key)
		new_enemy = enemy.instantiate()
		
	if CombatManager.stage >= 4 and CombatManager.stage < 7:
		var keys = temp_mid_enemy_pool.keys()
		var random_key = keys.pick_random()
		var enemy = temp_mid_enemy_pool[random_key]

		temp_mid_enemy_pool.erase(random_key)
		new_enemy = enemy.instantiate()
		
	if CombatManager.stage >= 7 and CombatManager.stage < 10:
		var keys = temp_late_enemy_pool.keys()
		var random_key = keys.pick_random()
		var enemy = temp_late_enemy_pool[random_key]

		temp_late_enemy_pool.erase(random_key)
		new_enemy = enemy.instantiate()
		
	if CombatManager.stage == 10:
		new_enemy = high_druid.instantiate()

	if CombatManager.stage > 10:
		var keys = endless_mode_pool.keys()
		var random_key = keys.pick_random()
		var enemy = endless_mode_pool[random_key]
		
		new_enemy = enemy.instantiate()

	
	Global.fight_scene.characters.add_child(new_enemy)
	Global.enemy = new_enemy
	Global.enemy.global_position = pos
	
	#set_background()
	#set_music()
		

	
