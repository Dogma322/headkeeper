extends Control
class_name MapScene

@onready var map: Map = $Map
@onready var player: Sprite2D = $Player
@onready var tooltip_panel: TooltipPanel = %TooltipPanel

func _ready() -> void:
	Transition.blackout_off()

func _on_exit_button_pressed() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/MainScenes/main_menu.tscn")


func _on_gen_button_pressed() -> void:
	map.generate()


func _on_map_node_mouse_entered(node: MapNode) -> void:
	tooltip_panel.description = "[center]Битва[/center]"
	tooltip_panel.show_tooltip()
	tooltip_panel.position = node.global_position - Vector2(tooltip_panel.size.x / 2.0, tooltip_panel.size.y)


func _on_map_node_mouse_exited() -> void:
	tooltip_panel.hide_tooltip()
