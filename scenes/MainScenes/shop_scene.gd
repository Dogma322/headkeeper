extends Control

@onready var exit_button: TextureButton = %ExitButton
@onready var slot_containers = [%HFlowContainer, %HFlowContainer2]
@onready var tooltip_panel: TooltipPanel = %TooltipPanel

var slots: Array[ShopSlot] = []

func _ready() -> void:
	Transition.blackout_off()
	load_slots()
	load_heads()
	tooltip_panel.reset_size()
	tooltip_panel.hide()


func _on_exit_button_pressed() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/MainScenes/main_menu.tscn")


func _on_exit_button_mouse_entered() -> void:
	exit_button.modulate = Color(1.3,1.3,1.3)


func _on_exit_button_mouse_exited() -> void:
	exit_button.modulate = Color(1,1,1)


func load_slots() -> void:
	for container in slot_containers:
		for child in container.get_children():
			if child is ShopSlot:
				child.icon_rect.mouse_entered.connect(_on_item_mouse_entered.bind(child))
				child.icon_rect.mouse_exited.connect(_on_item_mouse_exited)
				slots.push_back(child)


func _on_item_mouse_entered(item: ShopSlot) -> void:
	if not item.head:
		return
	tooltip_panel.caption = item.head.get_translated_name()
	tooltip_panel.description = item.head.get_translated_desc()
	tooltip_panel.show()
	await tooltip_panel.sort_children
	tooltip_panel.show_tooltip(item, item.tooltip_offset)


func _on_item_mouse_exited() -> void:
	tooltip_panel.hide_tooltip()


func load_heads() -> void:
	var pool = HeadManager.head_templates
	var i := 0
	for key in pool:
		slots[i].head = pool[key]
		i += 1
