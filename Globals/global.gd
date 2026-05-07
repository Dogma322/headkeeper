extends Node

var top_window: Control = null

func _ready() -> void:
	TranslationServer.set_locale("ru")
	load_settings()

@onready var hero: Hero
@onready var enemy: Enemy
@onready var fight_scene
@onready var board
@onready var board_bonus_container
@onready var head_holder
@onready var center_head_holder
@onready var enemy_head_holder
@onready var action_card_container
@onready var campfire_card_container
@onready var choice_scene
@onready var remove_domino_scene
@onready var play_btn
@onready var hand: Hand
@onready var map_scene
@onready var meta_scene: MetaScene
@onready var vhs_shader

@export var domino_scene = preload("res://scenes/Domino/domino.tscn")
@export var craft_scene = preload("res://scenes/MainScenes/craft_scene.tscn")

@onready var skulls_rewards = preload("res://resources/rewards/skulls_rewards.tres")

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_F:
			if enemy:
				Global.enemy.dead()


func save_settings():
	var file = FileAccess.open("user://settings.save", FileAccess.WRITE)
	
	var sfx_bus_index = AudioServer.get_bus_index("SFX")
	var music_bus_index = AudioServer.get_bus_index("Music")
	
	var json = JSON.stringify({
		"sfx_db": AudioServer.get_bus_volume_db(sfx_bus_index),
		"music_db": AudioServer.get_bus_volume_db(music_bus_index)
	})
	
	file.store_string(json)
	file.close()


func load_settings():
	if FileAccess.file_exists("user://settings.save"):
		var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("user://settings.save"))
		
		var sfx_bus_index = AudioServer.get_bus_index("SFX")
		var music_bus_index = AudioServer.get_bus_index("Music")
		
		AudioServer.set_bus_volume_db(
		sfx_bus_index,
		data.sfx_db)
		
		AudioServer.set_bus_volume_db(
		music_bus_index,
		data.music_db)
