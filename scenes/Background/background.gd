extends TextureRect
class_name Background

func set_main_menu_background() -> void:
	texture = load("res://assets/Backgrounds/VoidBackground.png")

func set_map_background():
	texture = load("res://assets/Backgrounds/VoidBackground.png")

func set_battle_background():
	if Global.enemy.location == "MushroomCaves":
		texture = load("res://assets/Backgrounds/DarkMushBackground2.png")
	if Global.enemy.location == "MutatingForest":
		texture = load("res://assets/Backgrounds/MutantForestGreen.png")
	if Global.enemy.location == "CursedSwamp":
		texture = load("res://assets/Backgrounds/SwampEternalSabbath.png")

func set_campfire_background():
	texture = preload("res://assets/Backgrounds/Pond.png")

func set_shop_background():
	texture = preload("res://assets/Backgrounds/Shop_Background.png")
