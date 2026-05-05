extends ScreenBase
class_name MapScene

@onready var map: Map = $Map
@onready var player: Sprite2D = $Player
@onready var tooltip_panel: TooltipPanel = %TooltipPanel
@onready var act_label: Label = %ActLabel

var moving = false
var selected_node: MapNode = null
var current_progress := 0
var player_origin : Vector2
var free_choice_mode := false

func reset():
	moving = false
	selected_node = null
	current_progress = 0
	player.position = player_origin
	map.generate()


func _ready() -> void:
	player_origin = player.position
	Global.map_scene = self
	Transition.blackout_off()


func start() -> void:
	SceneManager.background.set_map_background()
	Foreground.options_panel.show_box(Foreground.options_panel.map_box)


func _on_exit_button_pressed() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	Transition.blackout_off()
	hide()
	Global.meta_scene.show()


func _on_gen_button_pressed() -> void:
	reset()


func _on_map_node_mouse_entered(node: MapNode) -> void:
	match node.type:
		MapNode.Type.BATTLE:
			tooltip_panel.description = "[center]Битва с \"(%s)\"[/center]" % node.string_hint
		MapNode.Type.BATTLE_ELITE:
			tooltip_panel.description = "[center]Битва с элитным \"(%s)\"[/center]" % node.string_hint
		MapNode.Type.SHOP:
			tooltip_panel.description = "[center]Магазин[/center]"
		MapNode.Type.BONUS:
			tooltip_panel.description = "[center]Бонус[/center]"
		MapNode.Type.CAMPFIRE:
			tooltip_panel.description = "[center]Костер[/center]"
	tooltip_panel.show_tooltip()
	tooltip_panel.position = node.global_position - Vector2(tooltip_panel.size.x / 2.0, tooltip_panel.size.y + 10)

func _on_map_node_mouse_exited() -> void:
	tooltip_panel.hide_tooltip()


func _on_map_node_pressed(node: MapNode) -> void:
	if moving:
		return
	if SceneManager.main_scene != SceneManager.map_scene:
		return
	if not free_choice_mode:
		if selected_node == null:
			if node.coord.y != 0:
				return
			selected_node = node
		else:
			var found := false
			for node2 in selected_node.next:
				if node == node2:
					found = true
					break
			if not found:
				return
			selected_node = node
	else:
		selected_node = node
	current_progress += 1
	moving = true
	
	var tween = create_tween()
	tween.tween_property(player, "position", node.global_position, 0.5)
	await tween.finished
	
	match node.type:
		MapNode.Type.BATTLE:
			SceneManager.main_scene = SceneManager.battle_scene
			SceneManager.show_battle_scene(node, false)
		MapNode.Type.BATTLE_ELITE:
			SceneManager.main_scene = SceneManager.battle_scene
			SceneManager.show_battle_scene(node, true)
		MapNode.Type.SHOP:
			Transition.blackout_on()
			await get_tree().create_timer(1.0).timeout
			Transition.blackout_off()
			
			SceneManager.main_scene = SceneManager.shop_scene
			SceneManager.show_shop_scene()
			SceneManager.shop_scene.refill()
		MapNode.Type.BONUS:
			SceneManager.main_scene = SceneManager.action_card_scene
			SceneManager.show_action_card_scene()
			
			ActionCardManager.show_action_cards(node.stage)
			await Signals.action_card_selected
			
			Signals.bonus_amount_changed.emit()
			
			Transition.blackout_on()
			await get_tree().create_timer(1.0).timeout
			Transition.blackout_off()
			
			SceneManager.main_scene = SceneManager.map_scene
			SceneManager.show_map_scene()
		MapNode.Type.CAMPFIRE:
			SceneManager.main_scene = SceneManager.campfire_scene
			SceneManager.show_campfire_scene()
			
			await Signals.action_card_selected
			await get_tree().create_timer(0.5).timeout
			
			Transition.blackout_on()
			await get_tree().create_timer(1.0).timeout
			SceneManager.campfire_scene.end()
			Transition.blackout_off()
			
			SceneManager.main_scene = SceneManager.map_scene
			SceneManager.show_map_scene()
