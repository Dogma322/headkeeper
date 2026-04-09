extends Node2D

@export var is_temp := false

func _ready() -> void:
	if not is_temp:
		Global.fight_background = self

func set_background():
	if Global.enemy.location == "MushroomCaves":
		$Sprite2D.texture = load("res://assets/Backgrounds/DarkMushBackground2.png")
	if Global.enemy.location == "MutatingForest":
		$Sprite2D.texture = load("res://assets/Backgrounds/MutantForestGreen.png")
	if Global.enemy.location == "CursedSwamp":
		$Sprite2D.texture = load("res://assets/Backgrounds/SwampEternalSabbath.png")
