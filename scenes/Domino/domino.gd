class_name Domino
extends Node2D

@export_range(1, 4) var a:int:
	set(value):
		a = value
		top.count = a
		
@export_range(1, 4) var b:int:
	set(value):
		b = value
		bottom.count = b

@export var a_types: PackedStringArray
@export var b_types: PackedStringArray

@onready var ab_types = [a_types, b_types]

var a_color: String:
	set(value):
		a_color = value
		top.color = a_color
var b_color: String:
	set(value):
		b_color = value
		bottom.color = b_color

@export var template: DominoTemplate = null

var target_position:Vector2

var slot:DominoSlot = null
var connected_side := 1
var initial_connected_side := 1

var dragging := false
var returning_to_hand = false
var drag_offset := Vector2.ZERO
var domino_types = ["Attack"]

var val := {}
var tags := []

var vals := [{}, {}]
var accums := {}

var doubled = false

var mouse_over = false

var domino_choice = false
var deleted = false
var rotation_from = 0.0
var rotation_target = 0.0

const ROTATION_SPEED = 360.0*1.5

var rotation_prop:
	set(value):
		rotation_prop = value
		
		var v = lerp_angle(deg_to_rad(rotation_from), deg_to_rad(rotation_target), value)
		rotation_degrees = rad_to_deg(v)
		top.slots_rotation = -rotation_degrees
		bottom.slots_rotation = -rotation_degrees

var selection_tween: Tween
var rotation_tween: Tween

@onready var aim_marker = $AimMarker
@onready var top: DominoSideVisual = $Visual/Top
@onready var bottom: DominoSideVisual = $Visual/Bottom

@onready var dm_name: String
@onready var description: String = ""
@onready var tooltip_stack: HBoxContainer = %TooltipStack
@onready var tooltip_panel: TooltipPanel = %TooltipPanel
@onready var rect: Control = $Rect
@onready var domino_float: Sprite2D = %DominoFloat
@onready var trail: Line2D = $Trail
@onready var trail_particles: GPUParticles2D = $TrailParticles

const ADDITIONAL_TOOLTIP_PANEL = preload("uid://dnje7ugtetwov")

signal actions_completed

func set_additional_tooltip(type: String, key: String) -> void:
	for child in tooltip_stack.get_children():
		if child is AdditionalTooltipPanel:
			if child.key == key:
				return
	
	var panel = ADDITIONAL_TOOLTIP_PANEL.instantiate()
	panel.type = type
	panel.key = key
	tooltip_stack.add_child(panel)
	panel.hide()

class SideSettings:
	var types: PackedStringArray
	var color: String
	
	func _init(_types: PackedStringArray, _color = ""):
		types = _types
		color = _color


static var type_to_string = {
	"attack": ["Attack"],
	"attack2": ["Attack"],
	"defense": ["Defense"],
	"heal": ["Skill"],
	"vulnerable": ["Skill"],
	"weak": ["Skill"],
	"draw": ["Skill"],
	"spear": ["Attack"],
	"thorned_shield": ["Skill", "Defense"],
	"shield_strike": ["Attack", "Defense"],
	"shield": ["Defense"],
	"repeat": ["Skill"],
	"mace": ["Attack"],
	"horn": ["Skill"],
	"hammer": ["Attack"],
	"crit": ["Skill"],
	"dagger": ["Attack"],
	"corrupted_staff": ["Skill"],
	"corrupted_sphere": ["Skill"],
	"claws": ["Attack"],
	"skull": ["Attack"],
}

func setup(a_settings: SideSettings = null, b_settings: SideSettings = null) -> void:
	for stack in tooltip_stack.get_children():
		if stack is AdditionalTooltipPanel:
			stack.queue_free()
	
	if a_settings != null:
		for i in range(a_types.size()):
			remove_symbol(0, i)
		
		a = a_settings.types.size()
		
		a_types.clear()
		for i in range(a):
			a_types.push_back("empty")
		
		for type in a_settings.types:
			push_symbol(0, type)
		
		if a_settings.color != "":
			a_color = a_settings.color
	
	if b_settings != null:
		for i in range(b_types.size()):
			remove_symbol(1, i)
		
		b = b_settings.types.size()
		
		b_types.clear()
		for i in range(b):
			b_types.push_back("empty")
		
		for type in b_settings.types:
			push_symbol(1, type)
		
		if b_settings.color != "":
			b_color = b_settings.color

func _ready() -> void:
	if template != null:
		domino_types.clear()
		setup(SideSettings.new(template.a_types, template.a_color), SideSettings.new(template.b_types, template.b_color))
	#update_labels()
	hide_description_fast()


func add_actions():
	if DominoManager.double_next_dm > 0:
		print("DOUBLED")
		add_action()
		domino_played()
		DominoManager.double_next_dm -= 1
		doubled = true
	
	add_action()
	domino_played()


func get_status(target, status_id:String):
	for icon in target.status_container.get_children():
		if icon.status.id == status_id:
			return icon.status
	return null


func domino_played():
	Signals.domino_played.emit(self)
	
	for type in domino_types:
		if type == "Attack":
			Signals.attack_dm_played.emit(self)
		if type == "Defense":
			Signals.defense_dm_played.emit(self)
		if type == "Skill":
			Signals.skill_dm_played.emit(self)

	Signals._dm_played.emit(a, self)
	if a == 1:
		Signals._1dm_played.emit(self)
		DominoManager.value1_played_dominoes += 1
	if a == 2:
		Signals._2dm_played.emit(self)
		DominoManager.value2_played_dominoes += 1
	if a == 3:
		Signals._3dm_played.emit(self)
		DominoManager.value3_played_dominoes += 1
	if a == 4:
		Signals._4dm_played.emit(self)
		DominoManager.value4_played_dominoes += 1

	Signals._dm_played.emit(b, self)
	if b == 1:
		Signals._1dm_played.emit(self)
		if b != a:
			DominoManager.value1_played_dominoes += 1
	if b == 2:
		Signals._2dm_played.emit(self)
		if b != a:
			DominoManager.value2_played_dominoes += 1
	if b == 3:
		Signals._3dm_played.emit(self)
		if b != a:
			DominoManager.value3_played_dominoes += 1
	if b == 4:
		Signals._4dm_played.emit(self)
		if b != a:
			DominoManager.value4_played_dominoes += 1


func final_damage(_damage: int):
	if Global.enemy == null:
		return _damage
	var new_damage = ActionManager.calculate_damage(self, Global.enemy, _damage)
	return new_damage


func final_heal(_heal):
	return _heal


func final_corruption(_corruption):
	return _corruption


func get_open_value():

	if connected_side == 0:
		return b

	if connected_side == 1:
		return a

	return null


func final_block(_block):
	return ActionManager.calculate_block(_block)


func rotate_in_hand() -> void:
	if rotation_tween and rotation_tween.is_running():
		return
	
	if connected_side == 0:
		connected_side = 1
		initial_connected_side = 1
	else:
		connected_side = 0
		initial_connected_side = 0
	
	rotation_tween = create_tween()
	dm_rotate(rotation_degrees + 180.0, rotation_tween)


func rotate_to_match(dir: int, tween: Tween):
	var angle = 0.0

	match dir:
		DominoSlot.Direction.UP:
			angle = 180.0
		DominoSlot.Direction.DOWN:
			angle = 0.0
		DominoSlot.Direction.LEFT:
			angle = 90.0
		DominoSlot.Direction.RIGHT:
			angle = 270.0

	if connected_side == 1:
		angle += 180.0
	
	angle = fmod(angle, 360.0)
	
	dm_rotate(angle, tween)
	

func reset_rotation():
	var angle = 0.0
	if connected_side == 0:
		angle = 180.0
	if is_equal_approx(rotation_degrees, angle):
		return
	if rotation_tween and rotation_tween.is_running():
		return
	rotation_tween = create_tween()
	dm_rotate(angle, rotation_tween)


func dm_rotate(angle, tween):
	rotation_from = rotation_degrees
	rotation_target = angle
	rotation_prop = 0.0
	
	z_index = 1
	
	tween.tween_property(self, "rotation_prop", 1.0, 0.25)
	await tween.finished
	
	z_index = 0
	
	#if final_angle < 0:
		#final_angle += 360.0
	#if final_angle >= 180.0:
		#final_angle = 180.0
	#else:
		#final_angle = 0.0
	
	rotation_degrees = angle
	top.slots_rotation = -angle
	bottom.slots_rotation = -angle


func rotate_by_slot(connect_from: int, flow: int, side: int):

	var angle := 0

	# 🔥 откуда подключились
	match connect_from:
		0: angle = 0        # TOP
		1: angle = 180      # BOTTOM
		2: angle = -90      # LEFT
		3: angle = 90       # RIGHT

	# 🔥 куда идёт цепь
	match flow:
		1: angle -= 90      # LEFT
		2: angle += 90      # RIGHT

	# 🔥 переворот домино
	if side == 1:
		angle += 180

	rotation_degrees = angle % 360

	# 🔥 фикс иконок
	top.slots_rotation = -rotation_degrees
	bottom.slots_rotation = -rotation_degrees

func _on_area_2d_input_event(_viewport, event, _shape):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if DominoManager.block_domino_input:
				return
			if slot:
				return
			if event.pressed:
				rotate_in_hand()
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if not DominoManager.block_domino_input:
				hide_description_fast()
				
		
			if event.pressed:
				if DominoManager.block_domino_input:
					return
				
				if DominoManager.delete_mode:
					if !deleted:
						deleted = true
						remove_from_deck()
					return
				
				if domino_choice:
					if Global.choice_scene.choice_locked:
						return
					
					Global.choice_scene.choice_selected(self)
					add_domino_to_deck()
					Signals.domino_selected.emit()
					
				if slot:
					slot.remove_chain()
					#Global.hand.add_domino(self
				else:
					start_drag()
			else:
				stop_drag()


func is_tween_played():
	if rotate_tween and rotate_tween.is_running():
		return true
	if scale_tween and scale_tween.is_running():
		return true
	if deck_tween and deck_tween.is_running():
		return true
	return false


var saved_pos := Vector2.ZERO
var rotate_tween: Tween
var scale_tween: Tween
var deck_tween: Tween


#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			#if transformed:
				#transformed = false
				#if deck_tween and deck_tween.is_running():
					#deck_tween.kill()
				#if rotate_tween and rotate_tween.is_running():
					#rotate_tween.kill()
				#if scale_tween and scale_tween.is_running():
					#scale_tween.kill()
				#reset()

func reset() -> void:
	scale = Vector2(1, 1)
	domino_float.visible = false
	trail_particles.modulate = Color.WHITE
	trail.modulate = Color.WHITE
	trail.max_width = 60.0
	modulate.a = 1.0

func add_domino_to_deck():
	hide_description()
	
	domino_float.visible = true
	domino_float.modulate.a = 0.0
	
	trail_particles.modulate = Color.ORANGE
	trail.modulate = Color.ORANGE
	trail.max_trail_points = 30
	
	scale_tween = get_tree().create_tween().set_parallel()
	scale_tween.tween_property(self, "scale", Vector2(0.25, 0.25), 0.25)
	scale_tween.tween_property(trail, "max_width", 10.0, 0.25)
	
	rotate_tween = get_tree().create_tween()
	rotate_tween.tween_property(self, "rotation_degrees", rotation_degrees + 90, 0.125)
	rotate_tween.tween_property(self, "rotation_degrees", rotation_degrees, 0.125)
	
	deck_tween = get_tree().create_tween().set_parallel()
	var pos = SceneManager.top_panel.domino_deck_button.global_position + SceneManager.top_panel.domino_deck_button.size / 2.0
	
	var start_pos = global_position
	var mid_pos = (start_pos + pos) / 2.0 + Vector2(0, 200)
	
	deck_tween.tween_property(domino_float, "modulate:a", 1.0, 0.25)
	
	deck_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	deck_tween.tween_method(arc_move.bind(start_pos, mid_pos, pos), 0.0, 1.0, 0.75)
	
	deck_tween.chain()
	deck_tween.tween_property(self, "modulate:a", 0.0, 0.25)
	await deck_tween.finished
	
	DominoManager.temp_deck.append(self)
	DominoManager.deck.append(self)
	Signals.domino_amount_changed.emit()
	domino_choice = false
	
	await get_tree().create_timer(0.6).timeout
	reset()


func arc_move(t: float, start: Vector2, mid: Vector2, end: Vector2) -> void:
	var p0 = start.lerp(mid, t)
	var p1 = mid.lerp(end, t)
	global_position = p0.lerp(p1, t)


func remove_from_deck():
	Signals.domino_deleted_from_deck.emit()
	var tween = get_tree().create_tween()
	tween.set_parallel()

	tween.tween_property(self, "scale", Vector2(0,0), 0.25)
	tween.tween_property(self, "rotation_degrees", 180, 0.25)
	await tween.finished
	DominoManager.temp_deck.erase(self)
	DominoManager.deck.erase(self)
	Signals.domino_amount_changed.emit()
	queue_free()


func start_drag():
	if is_tween_played():
		return
	
	DominoManager.dm_dragging = true
	if returning_to_hand:
		return

	dragging = true
	Global.hand.remove_domino(self)
	drag_offset = global_position - get_global_mouse_position()
	z_index = 100
	
	if slot:
		slot.remove_chain()


func set_color(color : Color) -> void:
	top.modulate = color
	bottom.modulate = color
	pass


func _process(_delta):
	if dragging and slot == null:
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			stop_drag()
			return
		global_position = get_global_mouse_position() + drag_offset
	if tooltip_stack.top_level:
		tooltip_stack.position = Vector2(self.position.x - tooltip_stack.get_child(0).size.x / 2.0, self.position.y - tooltip_stack.size.y - 18 - 20)
	else:
		tooltip_stack.position = Vector2(rect.position.x + rect.size.x / 2.0 - tooltip_stack.get_child(0).size.x / 2.0, rect.position.y - tooltip_stack.size.y)


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_MOUSE_EXIT \
		or what == NOTIFICATION_APPLICATION_FOCUS_OUT \
		or what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		if dragging:
			stop_drag()


func stop_drag():
	DominoManager.dm_dragging = false
	if not dragging:
		return

	var target_slot = BoardManager.target_slot

  # Отключаем drag первым делом

	if target_slot and target_slot.can_place(self):
		if target_slot.domino:
			Global.hand.add_domino(target_slot.domino)
		target_slot.place_domino(self)
		BoardManager.target_slot = null
	else:
		Global.hand.add_domino(self)
		
	dragging = false
	
	if selection_tween and selection_tween.is_running():
		selection_tween.kill()
	selection_tween = create_tween().set_parallel()
	selection_tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0), 0.25)

	z_index = 0


func move_to_hand(pos:Vector2):
	returning_to_hand = true
	reset_rotation()
	connected_side = 1 
	
	var tween = create_tween()
	
	#stop_drag()
	
	tween.tween_property(
		self,
		"global_position",
		Global.hand.global_position + pos,
		0.3
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	
	await tween.finished
	returning_to_hand = false


func play_anim():
	Signals.play_domino_play_sound.emit()
	z_index = 100
	var tween = create_tween()
	tween.parallel()
	tween.tween_property(self, "scale", Vector2(1.4, 1.4), 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished
	z_index = 0


func _on_area_2d_mouse_entered() -> void:
	if !DominoManager.dm_dragging:
		if slot == null:
			if selection_tween and selection_tween.is_running():
				selection_tween.kill()
		
			selection_tween = create_tween().set_parallel()
			selection_tween.tween_property(self, "modulate", Color(1.5, 1.5, 1.5), 0.25)
			if SceneManager.battle_scene.is_visible_in_tree() or SceneManager.craft_scene.is_visible_in_tree():
				selection_tween.tween_property(self, "position:y", 310, 0.25)
		
		Signals.play_domino_draged_sound.emit()
		BoardManager.highlight_avaiable_slots([a,b])
	else:
		return
	mouse_over = true
	show_description()


func _on_area_2d_mouse_exited() -> void:
	if !DominoManager.dm_dragging:
		BoardManager.disable_highlight()
		if slot == null:
			if selection_tween and selection_tween.is_running():
				selection_tween.kill()
			
			selection_tween = create_tween().set_parallel()
			selection_tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0), 0.25)
			if SceneManager.battle_scene.is_visible_in_tree() or SceneManager.craft_scene.is_visible_in_tree():
				selection_tween.tween_property(self, "position:y", 320, 0.25)
	else:
		return
	mouse_over = false
	hide_description()


func show_description():
	if DominoManager.dm_dragging:
		return
	if dragging:
		return
	await update_labels()
	
	for panel in tooltip_stack.get_children():
		if panel is TooltipPanel:
			panel.z_index = 100
			panel.show_tooltip(true)


func hide_description():
	for panel in tooltip_stack.get_children():
		if panel is TooltipPanel:
			panel.hide_tooltip()
	

func hide_description_fast():
	for panel in tooltip_stack.get_children():
		panel.hide()


func update_labels():
	var tooltip := ""
	var i := 0
	for tag: String in tags:
		if i > 0:
			tooltip += "\n"
		var count = a_types.count(tag) + b_types.count(tag)
		var count_string = "" if count == 1 else "(%s)" % str(count)
		if DominoSideVisual.type_to_tex.has(tag):
			tooltip += "[img]%s[/img]%s - %s" % [DominoSideVisual.type_to_tex[tag]["red"].resource_path, count_string, get_tooltip_for_type(tag)]
			i += 1
		elif DominoSideVisual.special_to_tex.has(tag):
			tooltip += "[img]%s[/img]%s - %s" % [DominoSideVisual.special_to_tex[tag].resource_path, count_string, get_tooltip_for_type(tag)]
			i += 1
	tooltip_panel.description = tooltip


func add(type: String, value: int):
	if val.has(type):
		val[type] += value
	else:
		val[type] = value

func remove(type: String, value):
	if val.has(type):
		val[type] -= value
		if val[type] == 0:
			val.erase(type)

func has_empty_slot(side: int):
	var arr = a_types if side == 0 else b_types
	if arr.is_empty():
		return true
	
	for type in arr:
		if type == "empty":
			return true
	return false


func remove_symbol(side: int, index: int):
	var arr: PackedStringArray = ab_types[side]
	var key: String = arr[index]
	arr[index] = "empty"
	
	match key:
		"attack":
			remove(key, 1)
		"attack2":
			remove(key, 2)
		"defense":
			remove(key, 1)
		"heal":
			remove(key, 1)
		"draw":
			remove(key, 1)
		"corruption":
			remove(key, 1)
		"vulnerable":
			remove(key, 1)
		"weak":
			remove(key, 1)
		"fury":
			remove(key, 1)
		"thorns":
			remove(key, 1)
		"spear":
			remove(key, 3)
		"thorned_shield":
			remove(key, 2)
		"shield_strike":
			remove(key, 2)
		"shield":
			remove(key, 3)
		"repeat":
			remove(key, 1)
		"mace":
			remove(key, 3)
		"horn":
			remove(key, 1)
		"crit":
			remove(key, 1)
		"dagger":
			remove(key, 8)
		"corrupted_sphere":
			remove(key, 2)
		"claws":
			remove(key, 4)
			pass
	
	var found := false
	for types: PackedStringArray in ab_types:
		if key in types:
			found = true
			break
	
	if not found: # Полное удаление типа со всех сторон.
		tags.erase(key)
		
		for child in tooltip_stack.get_children():
			if child is AdditionalTooltipPanel:
				if child.key == key:
					child.queue_free()
		# Отсоединим сигналы.
		match key:
			"claws":
				accums[key] = 0
				if Signals.fight_started.is_connected(on_fight_started):
					Signals.fight_started.disconnect(on_fight_started)
			"corrupted_sphere":
				if Signals.skill_dm_played.is_connected(play):
					Signals.skill_dm_played.disconnect(play)
			"dagger":
				if Signals.hero_healed.is_connected(play):
					Signals.hero_healed.disconnect(play)
			"shield":
				if Signals.defense_dm_played.is_connected(play):
					Signals.defense_dm_played.disconnect(play)
			"spear":
				if Signals.attack_dm_played.is_connected(play):
					Signals.attack_dm_played.disconnect(play)
			"thorned_shield":
				if Signals._2dm_played.is_connected(play):
					Signals._2dm_played.disconnect(play)
		
		domino_types.clear()
		for types: PackedStringArray in ab_types:
			for type: String in types:
				if type_to_string.has(type):
					for domino_type in type_to_string[type]:
						if domino_type in domino_types:
							continue
						domino_types.push_back(domino_type)
	
	if side == 0:
		top.remove_symbol(index)
	else:
		bottom.remove_symbol(index)
	

func push_symbol(side: int, key: String, index := -1):
	if not has_empty_slot(side):
		if index == -1:
			# Уберем случайный символ.
			remove_symbol(side, randi_range(0, (a - 1) if side == 0 else (b - 1)))
		else:
			remove_symbol(side, index)
	
	for i in range(ab_types[side].size()):
		if ab_types[side][i] == "empty":
			ab_types[side][i] = key
			break
	
	if type_to_string.has(key):
		for domino_type in type_to_string[key]:
			if domino_type in domino_types:
				continue
			domino_types.push_back(domino_type)
	
	if not tags.has(key):
		tags.push_back(key)
	match key:
		"attack":
			add(key, 1)
		"attack2":
			add(key, 2)
		"defense":
			add(key, 1)
		"draw":
			add(key, 1)
		"heal":
			add(key, 1)
		"corruption":
			add(key, 1)
			set_additional_tooltip("Corruption", key)
		"vulnerable":
			add(key, 1)
			set_additional_tooltip("Vulnerable", key)
		"weak":
			add(key, 1)
			set_additional_tooltip("Weak", key)
		"fury":
			add(key, 1)
			set_additional_tooltip("Fury", key)
		"thorns":
			add(key, 1)
			set_additional_tooltip("Thorns", key)
		"spear":
			add(key, 3)
			if not Signals.attack_dm_played.is_connected(play):
				Signals.attack_dm_played.connect(play)
		"thorned_shield":
			add(key, 2)
			if not Signals._2dm_played.is_connected(play):
				Signals._2dm_played.connect(play)
		"shield_strike":
			add(key, 1)
		"shield":
			add(key, 3)
			if not Signals.defense_dm_played.is_connected(play):
				Signals.defense_dm_played.connect(play)
		"repeat":
			add(key, 1)
		"mace":
			add(key, 3)
		"horn":
			add(key, 1)
			if not Signals._3dm_played.is_connected(play):
				Signals._3dm_played.connect(play)
		"crit":
			add(key, 1)
		"dagger":
			add(key, 8)
			if not Signals.hero_healed.is_connected(play):
				Signals.hero_healed.connect(play.bind(null))
		"corrupted_sphere":
			add(key, 2)
			if not Signals.skill_dm_played.is_connected(play):
				Signals.skill_dm_played.connect(play)
		"claws":
			add(key, 4)
			accums[key] = 0
			if not Signals.fight_started.is_connected(on_fight_started):
				Signals.fight_started.connect(on_fight_started.bind(key))
	
	if side == 0:
		top.push_symbol(key)
	else:
		bottom.push_symbol(key)


func on_fight_started(key: String):
	if key == "claws":
		accums[key] = 0


func play(domino: Domino):
	if domino == self:
		return
	if slot:
		add_action()

func add_action() -> void:
	for key in tags:
		match key:
			"attack", "attack2", "dagger", "spear":
				ActionManager.add(AttackAction.new(self, Global.enemy, val[key]))
			"claws":
				ActionManager.add(AttackAction.new(self, Global.enemy, val[key] + accums[key]))
				accums[key] += 4
			"corruption", "corrupted_sphere":
				ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.corruption, val[key] + DominoManager.corruption_bonus))
			"defense":
				ActionManager.add(BlockAction.new(self, Global.hero, val[key]))
			"draw":
				ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.draw, val[key]))
			"fury":
				ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.fury, val[key]))
			"heal":
				ActionManager.add(HealAction.new(self, Global.hero, val[key]))
			"thorns":
				ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.thorns, val[key]))
			"thorned_shield":
				ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.thorns, val[key]))
			"shield_strike":
				ActionManager.add(ShieldStrikeAction.new(self, Global.enemy, val[key]))
			"repeat":
				ActionManager.add(BuffAction.new(self, Global.hero,StatusManager.repeat, val[key]))
				DominoManager.double_next_dm += val[key]
			"mace":
				ActionManager.add(AttackAction.new(self, Global.enemy, DominoManager.dominoes_on_board.size() * val[key]))
			"horn":
				ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.fury, val[key]))
			"hammer":
				ActionManager.add(HammerAction.new(self, Global.enemy))
			"crit":
				ActionManager.add(BuffAction.new(self, Global.hero,StatusManager.crit, val[key]))
			"corrupted_staff":
				ActionManager.add(CorruptedStaffAction.new(self, Global.enemy))
			"skull":
				ActionManager.add(SkullsAction.new(self, Global.enemy))
			"vulnerable":
				ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.vulnerable, val[key]))
			"weak":
				ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.weak, val[key]))


func get_tooltip_for_type(key: String) -> String:
	match key:
		"empty":
			return TextFormatter.highlight_keywords(tr("ID_EMPTY_DESC"))
		"attack", "attack2":
			return TextFormatter.insert_colored_value(tr("attack_des"), final_damage(val[key]), val[key])
		"corruption":
			return TextFormatter.insert_colored_value(tr("corruption_des"), final_corruption(val[key] + DominoManager.corruption_bonus), val[key])
		"defense":
			return TextFormatter.insert_colored_value(tr("defense_des"), final_block(val[key]), val[key])
		"draw":
			return TextFormatter.highlight_keywords(tr("draw_2+_des") % val[key])
		"fury":
			return TextFormatter.highlight_keywords(tr("strength_des") % val[key])
		"heal":
			return TextFormatter.highlight_keywords(tr("heal_des") % val[key])
		"vulnerable":
			return TextFormatter.highlight_keywords(tr("vulnerable_des") % val[key])
		"weak":
			return TextFormatter.highlight_keywords(tr("weak_des") % val[key])
		"thorns":
			return TextFormatter.highlight_keywords(tr("thorns_des") % val[key])
		"spear":
			return TextFormatter.insert_colored_value(tr("dm_spear_des"), final_damage(val[key]), val[key])
		"thorned_shield":
			return TextFormatter.insert_colored_value(tr("dm_thorned_shield_des"), final_block(val[key]), val[key])
		"shield_strike":
			var block = Global.hero.block + val.get("defense", 0)
			for domino: Domino in DominoManager.dominoes_on_board:
				block += domino.val.get("defense", 0)
			return TextFormatter.highlight_keywords(tr("DM_SHIELD_STRIKE_DESC") % [val[key], block * val[key]])
		"shield":
			return TextFormatter.insert_colored_value(tr("dm_steel_shield_des"), final_block(val[key]), val[key])
		"repeat":
			return TextFormatter.highlight_keywords(tr("dm_repeat_des"))
		"mace":
			var mace_damage = DominoManager.dominoes_on_board.size() * val[key] + val[key]
			return TextFormatter.insert_colored_value(tr("dm_mace_des"), final_damage(mace_damage), mace_damage + val[key])
		"horn":
			return TextFormatter.highlight_keywords(tr("dm_horn_des") % val[key])
		"hammer":
			var hammer_damage = BoardManager.green_bonuses_activated * 2
			return TextFormatter.insert_colored_value(tr("dm_hammer_des"), final_damage(hammer_damage), hammer_damage)
		"crit":
			return TextFormatter.highlight_keywords(tr("dm_crit_des"))
		"dagger":
			return TextFormatter.insert_colored_value(tr("dm_dagger_des"), final_damage(val[key]), val[key])
		"corrupted_staff":
			return TextFormatter.insert_colored_value(tr("dm_dark_staff_des"), final_corruption(DominoManager.value1_played_dominoes + DominoManager.corruption_bonus), DominoManager.value1_played_dominoes)
		"corrupted_sphere":
			return TextFormatter.insert_colored_value(tr("dm_dark_sphere_des"), final_corruption(val[key] + DominoManager.corruption_bonus), val[key])
		"claws":
			return TextFormatter.insert_colored_value(tr("dm_claws_des"), final_damage(val[key] + accums[key]), val[key] + accums[key])
		"skull":
			var damage_4d = DominoManager.value4_played_dominoes * 2
			return TextFormatter.insert_colored_value(tr("4value_attack_des"), final_damage(damage_4d), damage_4d)
	return ""
