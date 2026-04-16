extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	Global.background = self

func set_map_background():
	sprite_2d.texture = load("res://assets/Backgrounds/VoidBackground.png")

func set_battle_background():
	if Global.enemy.location == "MushroomCaves":
		sprite_2d.texture = load("res://assets/Backgrounds/DarkMushBackground2.png")
	if Global.enemy.location == "MutatingForest":
		sprite_2d.texture = load("res://assets/Backgrounds/MutantForestGreen.png")
	if Global.enemy.location == "CursedSwamp":
		sprite_2d.texture = load("res://assets/Backgrounds/SwampEternalSabbath.png")
