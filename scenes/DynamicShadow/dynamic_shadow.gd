extends Node2D

@onready var shadow = $Sprite2D

func _ready() -> void:
	shadow.modulate = Color("#19332d")
	Signals.stage_changed.connect(set_shadow)

func set_shadow():
	
	if Global.enemy.location == "MushroomCaves":
		shadow.modulate = Color("#462121")
	if Global.enemy.location == "CursedSwamp":
		shadow.modulate = Color("#402751")
	if Global.enemy.location == "MutatingForest":
		shadow.modulate = Color("#19332d")
