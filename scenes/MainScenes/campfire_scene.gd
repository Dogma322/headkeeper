extends Control
class_name CampfireScene

func start() -> void:
	SceneManager.background.set_campfire_background()
	pass

func end():
	SceneManager.background.set_map_background()
	ActionCardManager.action_card_is_pressed = false
