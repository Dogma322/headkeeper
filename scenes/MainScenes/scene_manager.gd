extends Control

@onready var map_scene: MapScene = $MapScene
@onready var battle_scene: BattleScene = $BattleScene
@onready var scenes = [map_scene, battle_scene]

var current_scene = null


func show_scene(scene):
	if current_scene == null:
		Transition.blackout_off()
	else:
		Transition.blackout_on()
		await get_tree().create_timer(1.0).timeout
	
	for scene2 in scenes:
		if scene2 == scene:
			scene2.show()
		else:
			scene2.hide()
	
	current_scene = scene


func new_run():
	#show_battle_scene()
	
	show_map_scene()
	map_scene.map.generate()


func show_map_scene():
	show_scene(map_scene)


func show_battle_scene():
	await show_scene(battle_scene)
	battle_scene.start()
