extends Node

var head_pool: = {
	"berserk": preload("res://scenes/Heads/hd_berserk.tscn"),
	"berserk1": preload("res://scenes/Heads/hd_berserk.tscn"),
	"berserk2": preload("res://scenes/Heads/hd_berserk.tscn"),
	"berserk3": preload("res://scenes/Heads/hd_berserk.tscn"),
	"berserk4": preload("res://scenes/Heads/hd_berserk.tscn"),
	"berserk5": preload("res://scenes/Heads/hd_berserk.tscn"),
	"berserk6": preload("res://scenes/Heads/hd_berserk.tscn"),
	"berserk7": preload("res://scenes/Heads/hd_berserk.tscn"),
	"berserk8": preload("res://scenes/Heads/hd_berserk.tscn"),
	"berserk9": preload("res://scenes/Heads/hd_berserk.tscn"),
}

var temp_head_pool = head_pool.duplicate()

func reset_head_pool():
	temp_head_pool = head_pool.duplicate()
