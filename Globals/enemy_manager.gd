extends Node

@onready var pool := {
	#region Early Enemies
	
	"tree": preload("res://scenes/Enemies/Forest/enm_tree.tscn"),
	"boar": preload("res://scenes/Enemies/Forest/enm_boar.tscn"),
	"deer": preload("res://scenes/Enemies/Forest/enm_deer.tscn"),
	
	"mushman2": preload("res://scenes/Enemies/MushCaves/enm_mushman_1.tscn"),
	"young_witch": preload("res://scenes/Enemies/Swamp/enm_young_witch_1.tscn"),
	"dark_witch": preload("res://scenes/Enemies/Swamp/enm_dark_witch_1.tscn"),
	"mush_warrior": preload("res://scenes/Enemies/MushCaves/enm_mush_warrior.tscn"),
	"mother_mush": preload("res://scenes/Enemies/MushCaves/enm_mother_mush.tscn"),
	
	#endregion
	
	#region Late Enemies
	
	"bear": preload("res://scenes/Enemies/Forest/enm_bear.tscn"),
	"cultist": preload("res://scenes/Enemies/Forest/enm_cultist.tscn"),
	"crowwoman": preload("res://scenes/Enemies/Forest/enm_crowwoman.tscn"),
	"wolf": preload("res://scenes/Enemies/Forest/enm_wolf.tscn"),
	"crowman": preload("res://scenes/Enemies/Forest/enm_crowman.tscn"),
	"mushroom_mage": preload("res://scenes/Enemies/Forest/enm_mushroom_mage.tscn"),
	
	"armored_mush2": preload("res://scenes/Enemies/MushCaves/enm_armored_mush.tscn"),
	"dark_witch2": preload("res://scenes/Enemies/Swamp/enm_dark_witch_2.tscn"),
	"mother_mush2": preload("res://scenes/Enemies/MushCaves/enm_mother_mus_2.tscn"),
	"elder_witch": preload("res://scenes/Enemies/Swamp/enm_elder_witch.tscn"),
	"horned_witch": preload("res://scenes/Enemies/Swamp/enm_horned_witch_2.tscn"),
	"turret": preload("res://scenes/Enemies/MushCaves/enm_turret.tscn"),
	"shadow": preload("res://scenes/Enemies/Swamp/enm_shadow.tscn"),
	"shadow_goat": preload("res://scenes/Enemies/Swamp/enm_shadow_goat.tscn"),
	"king": preload("res://scenes/Enemies/MushCaves/enm_king.tscn"),
	
	#endregion
	
	#region Elite Enemies
	
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

@onready var early_enemy_keys := [
	"mushroom_mage"
	
	#"tree",
	#"boar",
	#"deer",
	#
	#"mushman2",
	#"young_witch",
	#"dark_witch",
	#"mush_warrior",
	#"mother_mush",
]

@onready var late_enemy_keys := [
	"bear",
	"cultist",
	"crowwoman",
	"wolf",
	"crowman",
	"mushroom_mage",
	
	"armored_mush2",
	"dark_witch2",
	"mother_mush2",
	"elder_witch",
	"horned_witch",
	"turret",
	"shadow",
	"shadow_goat",
	"king",
]

@onready var elite_enemy_keys := [
	
]

@onready var endless_mode_keys := [
	"void_warriror",
	"void_wisp1",
	"void_wisp2",
	"endless_wolf",
	"endless_turret",
	"endless_young_witch"
]

@onready var temp_early_enemy_keys = early_enemy_keys.duplicate()
@onready var temp_late_enemy_keys = late_enemy_keys.duplicate()
@onready var temp_elite_enemy_keys = elite_enemy_keys.duplicate()


func _ready() -> void:
	Signals.reset_run_data.connect(reset_enemy_pools)


func reset_enemy_pools() -> void:
	temp_early_enemy_keys = early_enemy_keys.duplicate()
	temp_late_enemy_keys = late_enemy_keys.duplicate()
	temp_elite_enemy_keys = elite_enemy_keys.duplicate()


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
