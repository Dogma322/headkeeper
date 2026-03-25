extends Control

@onready var exit_button: TextureButton = %ExitButton
@onready var slot_containers = [%HFlowContainer, %HFlowContainer2]
@onready var tooltip_panel: TooltipPanel = %TooltipPanel
@onready var money_label: RichTextLabel = %MoneyLabel
@onready var shop_options_panel: Node2D = %ShopOptionsPanel
@onready var head_sprite: Sprite2D = %HeadSprite
@onready var head_animation_player: AnimationPlayer = %HeadAnimationPlayer

var slots: Array[ShopSlot] = []
var shop_cache = []

var started_money := 0
var showed_money := 0:
	set(value):
		showed_money = value
		money_label.text = "[img]res://assets/Icons/CommonSkull.png[/img]%s/%s" % [str(value), str(started_money)]

var money_tween: Tween
var selected_slot: ShopSlot = null

func _ready() -> void:
	head_sprite.texture = null
	Transition.blackout_off()
	load_slots()
	load_heads()
	started_money = MetaManager.money
	showed_money = MetaManager.money
	head_animation_player.play("head_anim")


func update_money_label():
	money_label.text = "[img]res://assets/Icons/CommonSkull.png[/img]%s" % str(MetaManager.money)


func _on_exit_button_pressed() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/MainScenes/main_menu.tscn")


func _on_exit_button_mouse_entered() -> void:
	exit_button.modulate = Color(1.3, 1.3, 1.3)


func _on_exit_button_mouse_exited() -> void:
	for item in shop_cache:
		MetaManager.buyed_head_keys.push_back(item.key)
	MetaManager.save_data()
	exit_button.modulate = Color(1, 1, 1)


func load_slots() -> void:
	for container in slot_containers:
		for child in container.get_children():
			if child is ShopSlot:
				child.icon_rect.mouse_entered.connect(_on_item_mouse_entered.bind(child))
				child.icon_rect.mouse_exited.connect(_on_item_mouse_exited)
				child.selected.connect(_on_item_selected.bind(child))
				slots.push_back(child)


func _on_item_selected(item: ShopSlot) -> void:
	if not item.head:
		return
	if item.buyed:
		if selected_slot != null and selected_slot != item:
			selected_slot.unselect()
		item.select()
		MetaManager.selected_head_key = item.key
		head_sprite.texture = item.head.texture
		selected_slot = item
	else:
		if item.try_buy(MetaManager.money):
			shop_cache.push_back(item)
			if item.head.cost > 0:
				if money_tween and money_tween.is_running():
					money_tween.kill()
				money_tween = create_tween()
				money_tween.tween_property(self, "showed_money", MetaManager.money - item.head.cost, 0.5)
				MetaManager.money -= item.head.cost
				update_availability()


func _on_item_mouse_entered(item: ShopSlot) -> void:
	if not item.head:
		return
	tooltip_panel.caption = item.head.get_translated_name()
	tooltip_panel.description = item.head.get_translated_desc()
	tooltip_panel.show_tooltip(true, item, item.tooltip_offset)


func _on_item_mouse_exited() -> void:
	tooltip_panel.hide_tooltip()


func update_availability() -> void:
	for slot in slots:
		slot.update_availability(MetaManager.money)


func load_heads() -> void:
	var pool = HeadManager.head_templates
	var i := 0
	for key in pool:
		slots[i].key = key
		slots[i].head = pool[key]
		if MetaManager.buyed_head_keys.has(key):
			slots[i].buyed = true
			if key == MetaManager.selected_head_key:
				slots[i].is_selected = true
				selected_slot = slots[i]
				head_sprite.texture = slots[i].head.texture
		else:
			slots[i].update_availability(MetaManager.money)
		i += 1


func _on_play_button_pressed() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/MainScenes/battle_scene.tscn")
