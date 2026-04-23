extends Control

## scene_manager.gd

@onready var map_scene: MapScene = %MapScene
@onready var battle_scene: BattleScene = %BattleScene
@onready var domino_list_scene: DominoListScene = %DominoListScene
@onready var action_card_scene: Control = %ActionCardScene
@onready var choice_scene: Node2D = %ChoiceScene
@onready var craft_scene: CraftScene = %CraftScene
@onready var remove_domino_scene: Node2D = %RemoveDominoScene
@onready var meta_scene: Control = %MetaScene
@onready var campfire_scene: CampfireScene = %CampfireScene
@onready var shop_scene: ShopScene = %ShopScene

@onready var scenes = [
	map_scene,
	battle_scene,
	domino_list_scene,
	action_card_scene,
	choice_scene,
	craft_scene,
	remove_domino_scene,
	meta_scene,
	campfire_scene,
	shop_scene,
]

@onready var back_button: IconButton = $BackButton
@onready var background: Background = %Background

var previous_scene = null
var current_scene = null
var main_scene = null


func show_scene(scene: Node) -> void:
	previous_scene = current_scene
	
	for scene2 in scenes:
		if scene2 == scene:
			scene2.show()
			current_scene = scene2
		else:
			scene2.hide()
	
	show_back_button(current_scene != main_scene)
	Signals.scene_changed.emit()


func show_previous_scene() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1.0).timeout
	Transition.blackout_off()
	
	show_scene(previous_scene)


func new_run() -> void:
	Global.vhs_shader.show()
	main_scene = map_scene
	show_map_scene()
	map_scene.map.generate()


func show_map_scene() -> void:
	background.set_map_background()
	show_scene(map_scene)
	map_scene.moving = false


func show_domino_list_scene(mode: DominoListScene.Source) -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1.0).timeout
	Transition.blackout_off()
	
	show_scene(domino_list_scene)
	domino_list_scene.update_domino_list(mode)


func show_battle_scene(map_node: MapNode) -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1.0).timeout
	
	show_scene(battle_scene)
	battle_scene.start()
	
	if map_node.coord.y == 0:
		CombatManager.start(map_node)
	else:
		CombatManager.change_stage(map_node)


func show_action_card_scene() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1.0).timeout
	Transition.blackout_off()
	
	show_scene(action_card_scene)


func show_choice_scene() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1.0).timeout
	Transition.blackout_off()
	
	show_scene(choice_scene)


func show_craft_scene(demo_mode: bool = false) -> void:
	show_scene(craft_scene)
	craft_scene.start(demo_mode)


func show_remove_domino_scene() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1.0).timeout
	Transition.blackout_off()
	
	show_scene(remove_domino_scene)
	remove_domino_scene.update_domino_list()


func show_meta_scene() -> void:
	show_scene(meta_scene)


func show_campfire_scene() -> void:
	show_scene(campfire_scene)
	campfire_scene.start()


func show_shop_scene() -> void:
	show_scene(shop_scene)
	shop_scene.start()


func show_back_button(enabled: bool) -> void:
	back_button.visible = enabled


func _on_back_button_pressed() -> void:
	if main_scene != null:
		show_scene(main_scene)
