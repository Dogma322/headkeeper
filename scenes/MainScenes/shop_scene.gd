extends Control

@onready var exit_button: TextureButton = %ExitButton
@onready var slot_containers = [%HFlowContainer, %HFlowContainer2]
@onready var tooltip_panel: TooltipPanel = %TooltipPanel
@onready var additional_tooltip_panel: MarginContainer = %AdditionalTooltipPanel
@onready var money_label: RichTextLabel = %MoneyLabel
@onready var shop_options_panel: Node2D = %ShopOptionsPanel
@onready var head_animation_player: AnimationPlayer = %HeadAnimationPlayer
@onready var head_marker_2d: Marker2D = %Marker2D
@onready var cancel_button: GameButton = %CancelButton

var slots: Array[ShopSlot] = []
var shop_cache: Array[ShopSlot] = []
var current_head: Head = null
var origin_head_slot: ShopSlot = null

var started_money := 0
var showed_money := 0:
	set(value):
		showed_money = value
		money_label.text = "[img]res://assets/Icons/CommonSkull.png[/img]%s/%s" % [str(value), str(started_money)]

var money_tween: Tween
var selected_slot: ShopSlot = null


func save_changes() -> void:
	for item in shop_cache:
		MetaManager.buyed_head_keys.push_back(item.key)
	MetaManager.save_data()


func play() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	save_changes()
	get_tree().change_scene_to_file("res://scenes/MainScenes/battle_scene.tscn")
	Global.fight_scene.start()


func exit() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	save_changes()
	get_tree().change_scene_to_file("res://scenes/MainScenes/main_menu.tscn")


func cancel() -> void:
	var cost := 0
	for slot in shop_cache:
		slot.is_selected = false
		slot.buyed = false
		cost += HeadManager.head_templates[slot.key].cost
		
	if cost != 0:
		if money_tween and money_tween.is_running():
			money_tween.kill()
		money_tween = create_tween()
		money_tween.tween_property(self, "showed_money", MetaManager.money + cost, 0.5)
		MetaManager.money += cost
	
	select_head(origin_head_slot)
	shop_cache.clear()
	cancel_button.disabled = true


func _ready() -> void:
	Transition.blackout_off()
	load_slots()
	load_heads()
	started_money = MetaManager.money
	showed_money = MetaManager.money
	head_animation_player.play("head_anim")
	cancel_button.disabled = true


func _on_exit_button_pressed() -> void:
	exit()


func load_slots() -> void:
	for container in slot_containers:
		for child in container.get_children():
			if child is ShopSlot:
				child.icon_rect.mouse_entered.connect(_on_item_mouse_entered.bind(child))
				child.icon_rect.mouse_exited.connect(_on_item_mouse_exited)
				child.selected.connect(_on_item_selected.bind(child))
				slots.push_back(child)


func select_head(slot: ShopSlot) -> void:
	if current_head:
		current_head.queue_free()
	if slot == null:
		MetaManager.selected_head_key = ""
	else:
		slot.select()
		var key = slot.key
		MetaManager.selected_head_key = key
		
		current_head = HeadManager.head_pool[key].instantiate()
		current_head.block_input = true
		head_marker_2d.add_child(current_head)
	selected_slot = slot


func _on_item_selected(item: ShopSlot) -> void:
	if not item.head:
		return
	if item.buyed:
		if selected_slot != null and selected_slot != item:
			selected_slot.unselect()
		select_head(item)
		
		var found := false
		for slot in shop_cache:
			if slot.key == item.key:
				found = true
				break
		if not found:
			origin_head_slot = item
		
		hide_tooltips()
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
				cancel_button.disabled = false


func _on_item_mouse_entered(item: ShopSlot) -> void:
	if not item.head or item.is_selected:
		return
	tooltip_panel.caption = item.head.get_translated_name()
	tooltip_panel.description = item.head.get_translated_desc()
	tooltip_panel.show_tooltip(true, item, item.tooltip_offset)
	if not item.head.extra_tags.is_empty():
		await get_tree().create_timer(0.01).timeout
		additional_tooltip_panel.type = item.head.extra_tags[0]
		additional_tooltip_panel.show_tooltip(true, tooltip_panel, item.tooltip_offset)


func _on_item_mouse_exited() -> void:
	hide_tooltips()


func hide_tooltips():
	tooltip_panel.hide_tooltip()
	if additional_tooltip_panel.visible:
		additional_tooltip_panel.hide_tooltip()


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
				origin_head_slot = selected_slot
				current_head = HeadManager.head_pool[key].instantiate()
				current_head.block_input = true
				head_marker_2d.add_child(current_head)
		else:
			slots[i].update_availability(MetaManager.money)
		i += 1


func _on_play_button_pressed() -> void:
	play()


func _on_cancel_button_pressed() -> void:
	cancel()
