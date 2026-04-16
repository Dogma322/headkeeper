extends Control

@onready var map_scene: MapScene = $MapScene
@onready var battle_scene: BattleScene = $BattleScene
@onready var scenes = [map_scene, battle_scene]


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
	show_scene(map_scene)
	map_scene.moving = false


func show_battle_scene():
	Transition.blackout_on()
	await get_tree().create_timer(1.0).timeout
	show_scene(battle_scene)
	battle_scene.start()
