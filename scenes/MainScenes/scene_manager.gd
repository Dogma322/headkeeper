extends Control

@onready var map_scene: MapScene = $MapScene
@onready var battle_scene: BattleScene = $BattleScene
@onready var domino_list_scene: DominoListScene = $DominoListScene
@onready var action_card_scene: Control = $ActionCardScene
@onready var choice_scene: Node2D = $ChoiceScene
@onready var craft_scene: Control = $CraftScene
@onready var remove_domino_scene: Node2D = $RemoveDominoScene
@onready var scenes = [
	map_scene,
	battle_scene,
	domino_list_scene,
	action_card_scene,
	choice_scene,
	craft_scene,
	remove_domino_scene
]

@onready var background: Node2D = $Background

var previous_scene = null
var current_scene = null


func show_scene(scene) -> void:
	previous_scene = current_scene
	
	for scene2 in scenes:
		if scene2 == scene:
			scene2.show()
			current_scene = scene2
		else:
			scene2.hide()


func show_previous_scene() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1.0).timeout
	Transition.blackout_off()
	
	show_scene(previous_scene)


func new_run():
	#show_battle_scene()
	Transition.blackout_off()
	show_map_scene()
	map_scene.map.generate()


func show_map_scene(use_transition_anim := false):
	if use_transition_anim:
		Transition.blackout_on()
		await get_tree().create_timer(1.0).timeout
		Transition.blackout_off()
	
	background.set_map_background()
	show_scene(map_scene)
	map_scene.moving = false


func show_domino_list_scene(mode):
	Transition.blackout_on()
	await get_tree().create_timer(1.0).timeout
	Transition.blackout_off()
	
	show_scene(domino_list_scene)
	domino_list_scene.update_domino_list(mode)
	

func show_battle_scene(map_node: MapNode):
	Transition.blackout_on()
	await get_tree().create_timer(1.0).timeout
	
	show_scene(battle_scene)
	if map_node.coord.y == 0:
		CombatManager.start(map_node)
	else:
		CombatManager.change_stage(map_node)


func show_action_card_scene():
	Transition.blackout_on()
	await get_tree().create_timer(1.0).timeout
	Transition.blackout_off()
	
	show_scene(action_card_scene)


func show_choice_scene():
	Transition.blackout_on()
	await get_tree().create_timer(1.0).timeout
	Transition.blackout_off()
	
	show_scene(choice_scene)


func show_craft_scene():
	Transition.blackout_on()
	await get_tree().create_timer(1.0).timeout
	Transition.blackout_off()
	
	show_scene(craft_scene)
	craft_scene.start()


func show_remove_domino_scene() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1.0).timeout
	Transition.blackout_off()
	
	show_scene(remove_domino_scene)
	remove_domino_scene.update_domino_list()
	
