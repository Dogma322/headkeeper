extends ScreenBase
class_name MetaScene

@onready var exit_button: IconButton = %ExitButton
@onready var slot_containers = [%HFlowContainer, %HFlowContainer2]
@onready var tooltip_panel: TooltipPanel = %TooltipPanel
@onready var additional_tooltip_panel: MarginContainer = %AdditionalTooltipPanel
@onready var skulls_label: RichTextLabel = %SkullsLabel
@onready var head_animation_player: AnimationPlayer = %HeadAnimationPlayer
@onready var head_marker_2d: Marker2D = %Marker2D
@onready var cancel_button: GameButton = %CancelButton

var slots: Array[MetaSlot] = []
var shop_cache: Array[MetaSlot] = []
var current_head: Head = null
var origin_head_slot: MetaSlot = null

var started_skulls := 0
var showed_skulls := 0:
	set(value):
		showed_skulls = value
		skulls_label.text = "[img]res://assets/Icons/CommonSkull.png[/img]%s" % [str(value)]

var skulls_tween: Tween
var selected_slot: MetaSlot = null
var head_tween: Tween


func save_changes() -> void:
	for item in shop_cache:
		MetaManager.buyed_head_keys.push_back(item.key)
	MetaManager.save_data()


func play() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	Transition.blackout_off()
	end()
	
	hide()
	save_changes()
	SceneManager.new_run()


func exit() -> void:
	save_changes()
	Global.save_settings()
	get_tree().quit()


func cancel() -> void:
	var cost := 0
	for slot in shop_cache:
		slot.is_selected = false
		slot.buyed = false
		cost += HeadManager.head_templates[slot.key].skulls_cost
		
	if cost != 0:
		if skulls_tween and skulls_tween.is_running():
			skulls_tween.kill()
		skulls_tween = create_tween()
		skulls_tween.tween_property(self, "showed_skulls", MetaManager.skulls + cost, 0.5)
		MetaManager.skulls += cost
	
	if origin_head_slot != null and not origin_head_slot.is_selected:
		select_head(origin_head_slot)
	shop_cache.clear()
	cancel_button.disabled = true


func start() -> void:
	Signals.head_selected.connect(_on_head_selected)
	
	started_skulls = MetaManager.skulls
	showed_skulls = MetaManager.skulls
	
	for slot in slots:
		slot.update_availability(MetaManager.skulls)

	if not MetaManager.selected_head_key.is_empty():
		current_head = HeadManager.head_pool[MetaManager.selected_head_key].instantiate()
		current_head.head_choice = true
		head_marker_2d.add_child(current_head)


func end() -> void:
	Signals.head_selected.disconnect(_on_head_selected)
	current_head.queue_free()


func _ready() -> void:
	Transition.blackout_off()
	load_slots()
	load_heads()
	started_skulls = MetaManager.skulls
	showed_skulls = MetaManager.skulls
	head_animation_player.play("head_anim")
	cancel_button.disabled = true
	
	Foreground.options_panel.show_box(Foreground.options_panel.meta_box)
	Global.meta_scene = self
	SoundManager.set_music("MainMenu")
	Signals.head_selected.connect(_on_head_selected)


func deselect_slot(head):
	if head_tween and head_tween.is_running():
		return
	var found := false
	for slot in shop_cache:
		if slot.key == selected_slot.key:
			found = true
			break
	if not found:
		origin_head_slot = null
	head_tween = create_tween()
	head_tween.tween_property(head, "global_position", selected_slot.center, 0.25)
	await head_tween.finished
	selected_slot.unselect()
	head.queue_free()
	MetaManager.selected_head_key = ""
	
	selected_slot = null


func _on_head_selected(head: Head) -> void:
	deselect_slot(head)


func _on_exit_button_pressed() -> void:
	exit()


func load_slots() -> void:
	for container in slot_containers:
		for child in container.get_children():
			if child is MetaSlot:
				child.icon_rect.mouse_entered.connect(_on_item_mouse_entered.bind(child))
				child.icon_rect.mouse_exited.connect(_on_item_mouse_exited)
				child.selected.connect(_on_item_selected.bind(child))
				slots.push_back(child)


func select_head(slot: MetaSlot) -> void:
	if slot == null:
		MetaManager.selected_head_key = ""
		if current_head:
			current_head.queue_free()
	else:
		if slot.is_selected:
			deselect_slot(current_head)
			return
		var found := false
		for slot2 in shop_cache:
			if slot2.key == slot.key:
				found = true
				break
		if not found:
			origin_head_slot = slot
		head_tween = create_tween().set_parallel()
		var prev_head = null
		if current_head:
			prev_head = current_head
			head_tween.tween_property(current_head, "global_position", selected_slot.center, 0.25)
		slot.select()
		var key = slot.key
		MetaManager.selected_head_key = key
		
		current_head = HeadManager.head_pool[key].instantiate()
		current_head.head_choice = true
		head_marker_2d.add_child(current_head)
		current_head.global_position = slot.center
		
		head_tween.tween_property(current_head, "global_position", head_marker_2d.global_position, 0.25)
		await head_tween.finished
		if prev_head:
			prev_head.queue_free()
		if selected_slot != null and selected_slot != slot:
			selected_slot.unselect()
		
	selected_slot = slot


func _on_item_selected(item: MetaSlot) -> void:
	if not item.head:
		return
	if item.buyed:
		select_head(item)
		hide_tooltips()
	else:
		if item.try_buy(MetaManager.skulls):
			shop_cache.push_back(item)
			if item.head.skulls_cost > 0:
				if skulls_tween and skulls_tween.is_running():
					skulls_tween.kill()
				skulls_tween = create_tween()
				skulls_tween.tween_property(self, "showed_skulls", MetaManager.skulls - item.head.skulls_cost, 0.5)
				MetaManager.skulls -= item.head.skulls_cost
				
				update_availability()
				cancel_button.disabled = false


func _on_item_mouse_entered(item: MetaSlot) -> void:
	if not item.head or item.is_selected:
		return
	tooltip_panel.caption = item.hname
	tooltip_panel.description = item.description
	tooltip_panel.show_tooltip(true, item, item.tooltip_offset)
	if not item.head.extra_tags.is_empty():
		await get_tree().create_timer(0.01).timeout
		additional_tooltip_panel.type = item.head.extra_tags[0]
		additional_tooltip_panel.show_tooltip(true, tooltip_panel, item.tooltip_offset)


func _on_item_mouse_exited() -> void:
	hide_tooltips()


func hide_tooltips() -> void:
	tooltip_panel.hide_tooltip()
	if additional_tooltip_panel.visible:
		additional_tooltip_panel.hide_tooltip()


func update_availability() -> void:
	for slot in slots:
		slot.update_availability(MetaManager.skulls)


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
				current_head.head_choice = true
				head_marker_2d.add_child(current_head)
		else:
			slots[i].update_availability(MetaManager.skulls)
		i += 1


func _on_cancel_button_pressed() -> void:
	cancel()


func _on_play_button_pressed() -> void:
	play()
