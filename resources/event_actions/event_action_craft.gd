extends EventAction
class_name EventActionCraft

## Действие события - открытие экрана крафта со специфическими настройками.

@export var can_reroll: bool = true

@export var craft_receipts: Array[CraftRecipe]

func _init() -> void:
	pass_to_screen = true

func play() -> void:
	SceneManager.main_scene = SceneManager.craft_scene
	SceneManager.show_craft_scene(self)
