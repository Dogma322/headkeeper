extends Node

func _ready() -> void:
	TranslationServer.set_locale("ru")

@onready var hero
@onready var enemy
@onready var fight_scene
@onready var board
@onready var board_bonus_container
@onready var head_holder
