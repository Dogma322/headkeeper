extends Node

var head_pool: = {
	"berserk": preload("res://scenes/Heads/hd_berserk.tscn"),
	"squid": preload("res://scenes/Heads/hd_squid.tscn"),
	"white_thorn": preload("res://scenes/Heads/hd_white_thorn.tscn"),
	"eternal_fury": preload("res://scenes/Heads/hd_eternal_fury.tscn"),
	#"moon": preload("res://scenes/Heads/hd_moon.tscn"),
	"chaos": preload("res://scenes/Heads/hd_chaos.tscn"),
	"corruptor": preload("res://scenes/Heads/hd_corruptor.tscn"),
	"druid": preload("res://scenes/Heads/hd_druid.tscn"),
	"phantom": preload("res://scenes/Heads/hd_phantom.tscn"),
	"apostle": preload("res://scenes/Heads/hd_apostle.tscn"),
	"construct": preload("res://scenes/Heads/hd_construct.tscn"),
	"plant": preload("res://scenes/Heads/hd_plant.tscn"),
	"rock": preload("res://scenes/Heads/hd_rock.tscn"),
	"false_king": preload("res://scenes/Heads/hd_false_king.tscn"),
	"maw": preload("res://scenes/Heads/hd_maw.tscn")
}

var head_templates = {
	"berserk": preload("res://resources/heads/head_berserk.tres"),
	"squid": preload("res://resources/heads/head_squid.tres"),
	"white_thorn": preload("res://resources/heads/head_white_thorn.tres"),
	"eternal_fury": preload("res://resources/heads/head_eternal_fury.tres"),
	#"moon": preload("res://resources/heads/head_moon.tres"),
	"chaos": preload("res://resources/heads/head_chaos.tres"),
	"corruptor": preload("res://resources/heads/head_corruptor.tres"),
	"druid": preload("res://resources/heads/head_druid.tres"),
	"phantom": preload("res://resources/heads/head_phantom.tres"),
	"apostle": preload("res://resources/heads/head_apostle.tres"),
	"construct": preload("res://resources/heads/head_construct.tres"),
	"plant": preload("res://resources/heads/head_plant.tres"),
	"rock": preload("res://resources/heads/head_rock.tres"),
	"false_king": preload("res://resources/heads/head_false_king.tres"),
	"maw": preload("res://resources/heads/head_maw.tres"),
}

var temp_head_pool = head_pool.duplicate()

func _ready() -> void:
	Signals.reset_run_data.connect(reset_head_pool)

func reset_head_pool():
	temp_head_pool = head_pool.duplicate()
	for head in Global.head_holder.get_children():
		head.remove_passive_effect()
