extends TextureRect
class_name Background

@onready var forest: Node2D = $Forest

func hide_scenery() -> void:
	forest.hide()

func set_main_menu_background() -> void:
	hide_scenery()
	texture = load("res://assets/Backgrounds/VoidBackground.png")

func set_map_background():
	hide_scenery()
	texture = load("res://assets/Backgrounds/VoidBackground.png")

func set_battle_background():
	hide_scenery()
	if Global.enemy.location == "MushroomCaves":
		texture = load("res://assets/Backgrounds/DarkMushBackground2.png")
	if Global.enemy.location == "MutatingForest":
		texture = load("res://assets/Backgrounds/forest_1/forest_background1_1.png")
		forest.show()
	if Global.enemy.location == "CursedSwamp":
		texture = load("res://assets/Backgrounds/SwampEternalSabbath.png")

func set_campfire_background():
	hide_scenery()
	texture = preload("res://assets/Backgrounds/Pond.png")

func set_shop_background():
	hide_scenery()
	texture = preload("res://assets/Backgrounds/Shop_Background.png")
