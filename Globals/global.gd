extends Node

func _ready() -> void:
	TranslationServer.set_locale("ru")

@onready var hero
@onready var enemy: Enemy
@onready var fight_scene
@onready var board
@onready var board_bonus_container
@onready var head_holder
@onready var action_card_container
@onready var choice_scene
@onready var fight_background
@onready var remove_domino_scene
@onready var play_btn 

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_F:
			if enemy:
				enemy.dead()
