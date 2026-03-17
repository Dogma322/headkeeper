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

var temp_head_pool = head_pool.duplicate()

func reset_head_pool():
	temp_head_pool = head_pool.duplicate()
