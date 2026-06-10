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
	if not dir_path.begins_with("res://"):
		dir_path = "res://" + dir_path
	
	templates.clear()
	
	var all_files = find_all_tres_files(dir_path, excluded_folders)
	for file_path in all_files:
		var key = file_path.get_file().get_basename()
		templates[key] = load(file_path)


func find_all_tres_files(base_path: String, excluded: PackedStringArray) -> Array[String]:
	var results: Array[String] = []
	
	var dir = DirAccess.open(base_path)
	if dir == null:
		return results
	
	dir.include_navigational = false
	dir.list_dir_begin()
	
	var entries = []
	var entry = dir.get_next()
	while entry != "":
		entries.append(entry)
		entry = dir.get_next()
	dir.list_dir_end()
	
	for e in entries:
		var full_path = base_path + "/" + e
		if DirAccess.dir_exists_absolute(full_path):
			if not e in excluded:
				results.append_array(find_all_tres_files(full_path, excluded))
		elif e.ends_with(".tres.remap"):
			results.append(full_path.replace(".tres.remap", ".tres"))
		elif e.ends_with(".tres"):
			results.append(full_path)
	
	return results
