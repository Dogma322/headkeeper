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


func load_templates(folder: String, templates: Dictionary, excluded_folders: PackedStringArray = []) -> void:
	var dir_path = folder
	var dir = DirAccess.open(dir_path)
	if dir == null:
		push_warning("Could not open directory: " + dir_path)
		return
	
	templates.clear()
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			# Skip 'start' folder
			if not file_name in excluded_folders:
				load_templates_from_subdir(dir_path + "/" + file_name, templates)
		else:
			# Check if it's a .tres file in root dominoes folder
			if file_name.ends_with(".tres"):
				var key = file_name.get_basename()
				var resource_path = dir_path + "/" + file_name
				templates[key] = load(resource_path)
		file_name = dir.get_next()
	dir.list_dir_end()


func load_templates_from_subdir(subdir_path: String, templates: Dictionary) -> void:
	var subdir = DirAccess.open(subdir_path)
	if subdir == null:
		return
	
	subdir.list_dir_begin()
	var file_name = subdir.get_next()
	while file_name != "":
		if not subdir.current_is_dir() and file_name.ends_with(".tres"):
			var key = file_name.get_basename()
			var resource_path = subdir_path + "/" + file_name
			templates[key] = load(resource_path)
		file_name = subdir.get_next()
	subdir.list_dir_end()
