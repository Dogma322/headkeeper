extends Control

@onready var map_scene: MapScene = $MapScene
@onready var battle_scene: BattleScene = $BattleScene
@onready var domino_list_scene: DominoListScene = %DominoListScene
@onready var scenes = [map_scene, battle_scene, domino_list_scene]
@onready var background: Node2D = $Background

func show_scene(scene):
	for scene2 in scenes:
		if scene2 == scene:
			scene2.show()
		else:
			scene2.hide()


func new_run():
	#show_battle_scene()
	Transition.blackout_off()
	show_map_scene()
	map_scene.map.generate()


func show_map_scene():
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

func show_battle_scene_immediate() -> void:
	Transition.blackout_off()
	show_scene(battle_scene)
