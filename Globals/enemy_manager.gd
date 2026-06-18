extends Node

@onready var wolf1 = preload("res://scenes/Enemies/Forest/enm_wolf_1.tscn")

#@onready var tutorial_mushman = preload("res://scenes/Enemies/MushroomCaves/enm_tutorial_mushman.tscn")
#@onready var wolf1 = preload("res://scenes/Enemies/Forest/enm_wolf_1.tscn")
#@onready var high_druid = preload("res://scenes/Enemies/Forest/enm_high_druid.tscn")

@onready var pool := {
	#region Tutorial Enemies
	
	"wolf1": preload("res://scenes/Enemies/Forest/enm_wolf_1.tscn"),
	
	#endregion
	
	#region Early Enemies
	
	"mushman2": preload("res://scenes/Enemies/MushCaves/enm_mushman_1.tscn"),
	"young_witch": preload("res://scenes/Enemies/Swamp/enm_young_witch_1.tscn"),
	"cultist1": preload("res://scenes/Enemies/Forest/enm_cultist_1.tscn"),
	"dark_witch": preload("res://scenes/Enemies/Swamp/enm_dark_witch_1.tscn"),
	"mush_warrior": preload("res://scenes/Enemies/MushCaves/enm_mush_warrior.tscn"),
	"mother_mush": preload("res://scenes/Enemies/MushCaves/enm_mother_mush.tscn"),
	"tree": preload("res://scenes/Enemies/Forest/enm_tree.tscn"),
	"boar1": preload("res://scenes/Enemies/Forest/enm_boar_1.tscn"),
	
	#endregion
	
	#region Middle Enemies
	
	"armored_mush2": preload("res://scenes/Enemies/MushCaves/enm_armored_mush.tscn"),
	"cultist2": preload("res://scenes/Enemies/Forest/enm_cultist_2.tscn"),
	"dark_witch2": preload("res://scenes/Enemies/Swamp/enm_dark_witch_2.tscn"),
	"mother_mush2": preload("res://scenes/Enemies/MushCaves/enm_mother_mus_2.tscn"),
	"deer2": preload("res://scenes/Enemies/Forest/enm_deer_2.tscn"),
	"elder_witch": preload("res://scenes/Enemies/Swamp/enm_elder_witch.tscn"),
	"horned_witch": preload("res://scenes/Enemies/Swamp/enm_horned_witch_2.tscn"),
	"turret": preload("res://scenes/Enemies/MushCaves/enm_turret.tscn"),
	"shadow": preload("res://scenes/Enemies/Swamp/enm_shadow.tscn"),
	
	#endregion
	
	#region Late Enemies
	
	"crowman": preload("res://scenes/Enemies/Forest/enm_crowman.tscn"),
	"crowwoman": preload("res://scenes/Enemies/Forest/enm_crowwoman.tscn"),
	"wolf2": preload("res://scenes/Enemies/Forest/enm_wolf_2.tscn"),
	"shadow_goat": preload("res://scenes/Enemies/Swamp/enm_shadow_goat.tscn"),
	"bear": preload("res://scenes/Enemies/Forest/enm_bear.tscn"),
	"king": preload("res://scenes/Enemies/MushCaves/enm_king.tscn"),
	"high_druid": preload("res://scenes/Enemies/Forest/enm_high_druid.tscn"),
	
	#endregion
	
	#region Bosses
	
	"boss1": preload("res://scenes/Enemies/Bosses/enm_boss1.tscn"),
	
	#endregion
	
	#region Endless Enemies
	
	"void_warriror": preload("res://scenes/Enemies/EndlessMode/enm_void_warrior_1.tscn"),
	"void_wisp1": preload("res://scenes/Enemies/EndlessMode/enm_void_wisp_1.tscn"),
	"void_wisp2": preload("res://scenes/Enemies/EndlessMode/enm_void_wisp_2.tscn"),
	"endless_wolf": preload("res://scenes/Enemies/EndlessMode/enm_endless_wolf.tscn"),
	"endless_turret": preload("res://scenes/Enemies/EndlessMode/enm_endless_turret.tscn"),
	"endless_young_witch": preload("res://scenes/Enemies/EndlessMode/enm_endless_young_witch.tscn")
	
	#endregion
}

@onready var early_enemy_keys: = [
	"mushman2",
	"young_witch",
	"cultist1",
	"dark_witch",
	"mush_warrior",
	"mother_mush",
	"tree",
	"boar1"
]

@onready var mid_enemy_keys: = [
	"armored_mush2",
	"cultist2",
	"dark_witch2",
	"mother_mush2",
	"deer2",
	"elder_witch",
	"horned_witch",
	"turret",
	"shadow"
]

@onready var late_enemy_keys: = [
	"crowman",
	"crowwoman",
	"wolf2",
	"shadow_goat",
	"bear",
	"king",
	"high_druid",
]

@onready var endless_mode_keys: = [
	"void_warriror",
	"void_wisp1",
	"void_wisp2",
	"endless_wolf",
	"endless_turret",
	"endless_young_witch"
]

@onready var temp_early_enemy_keys = early_enemy_keys.duplicate()
@onready var temp_mid_enemy_keys = mid_enemy_keys.duplicate()
@onready var temp_late_enemy_keys = late_enemy_keys.duplicate()


func _ready() -> void:
	Signals.reset_run_data.connect(reset_enemy_pools)


func reset_enemy_pools() -> void:
	temp_early_enemy_keys = early_enemy_keys.duplicate()
	temp_mid_enemy_keys = mid_enemy_keys.duplicate()
	temp_late_enemy_keys = late_enemy_keys.duplicate()


func set_enemy(map_node: MapNode) -> void:
	if Global.enemy:
		Global.enemy.queue_free()
	
	var new_enemy
	var enemy: PackedScene = null
	
	if pool.has(map_node.string_hint):
		enemy = pool[map_node.string_hint]
	
	new_enemy = enemy.instantiate()
	
	Global.fight_scene.enemy_spawn_pos.add_child(new_enemy)
	Global.enemy = new_enemy
	Global.enemy_head_holder.global_position.y = new_enemy.intent_icon.global_position.y - 16
	
	#set_background()
	#set_music()
