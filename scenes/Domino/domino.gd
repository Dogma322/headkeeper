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

var mouse_over_des = false

var domino_choice = false
var deleted = false

@onready var aim_marker = $AimMarker
@onready var top: DominoSideVisual = $Visual/Top
@onready var bottom: DominoSideVisual = $Visual/Bottom

@onready var dm_name: String
@onready var description: String = ""
@onready var tooltip_stack: HBoxContainer = %TooltipStack
@onready var tooltip_panel: TooltipPanel = %TooltipPanel

const ADDITIONAL_TOOLTIP_PANEL = preload("uid://dnje7ugtetwov")
var extra_tooltip_panel: AdditionalTooltipPanel = null

func set_additional_tooltip(type: String, key: String) -> void:
	if extra_tooltip_panel == null:
		extra_tooltip_panel = ADDITIONAL_TOOLTIP_PANEL.instantiate()
		extra_tooltip_panel.type = type
		extra_tooltip_panel.key = key
		tooltip_stack.add_child(extra_tooltip_panel)
	else:
		extra_tooltip_panel.type = type
		extra_tooltip_panel.key = key

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
	"corrupted_stuff": ["Skill"],
	"corrupted_sphere": ["Skill"],
	"claws": ["Attack"],
	"skull": ["Attack"],
}

func setup(a_settings: SideSettings = null, b_settings: SideSettings = null) -> void:
	if extra_tooltip_panel != null:
		extra_tooltip_panel.queue_free()
		extra_tooltip_panel = null
	
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
	
	Signals.domino_played.emit()
	
	for type in domino_types:
		if type == "Attack":
			Signals.attack_dm_played.emit(self)
		if type == "Defense":
			Signals.defense_dm_played.emit(self)
		if type == "Skill":
			Signals.skill_dm_played.emit(self)

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
	var angle = 0
	if connected_side == 0:
		connected_side = 1
		initial_connected_side = 1
	else:
		connected_side = 0
		initial_connected_side = 0
		angle = 180
	
	rotation_degrees = angle % 360
	tooltip_stack.global_position = global_position - Vector2(61, 32) - Vector2(0, tooltip_stack.get_child(0).size.y)
	
	top.slots_rotation = -rotation_degrees
	bottom.slots_rotation = -rotation_degrees

func rotate_to_match(required_value: int, dir: int):
	var angle = 0

	match dir:
		DominoSlot.Direction.UP:
			angle = 180
		DominoSlot.Direction.DOWN:
			angle = 0
		DominoSlot.Direction.LEFT:
			angle = 90
		DominoSlot.Direction.RIGHT:
			angle = 270

	if connected_side == 1:
		angle += 180

	rotation_degrees = angle % 360
	
	top.slots_rotation = -rotation_degrees
	bottom.slots_rotation = -rotation_degrees

func reset_rotation():
	var angle = 0
	if connected_side == 0:
		angle = 180
	# Сбрасываем основное вращение домино
	rotation_degrees = angle
	# Сбрасываем вращение иконок
	if top:
		top.slots_rotation = angle
	if bottom:
		bottom.slots_rotation = angle

func rotate_by_slot(connect_from: int, flow: int, connected_side: int):

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
	if connected_side == 1:
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
					else:
						return
				
				if domino_choice:
					if Global.choice_scene.choice_locked:
						return
					Global.choice_scene.choice_selected(self)
					add_domino_to_deck()
					Signals.domino_selected.emit()
					return
					
				if slot:
					slot.remove_chain()
					#Global.hand.add_domino(self
				else:
					start_drag()
			else:
				stop_drag()

func add_domino_to_deck():
	var tween = get_tree().create_tween()
	var pos = Vector2(15,300)
	tween.set_parallel()
	tween.tween_property(self, "global_position", pos, 0.5)
	tween.tween_property(self, "scale", Vector2(0,0), 0.5)
	DominoManager.temp_deck.append(self)
	domino_choice = false


func remove_from_deck():
	Signals.domino_deleted_from_deck.emit()
	var tween = get_tree().create_tween()
	tween.set_parallel()

	tween.tween_property(self, "scale", Vector2(0,0), 0.25)
	tween.tween_property(self, "rotation_degrees", 180, 0.25)
	await tween.finished
	DominoManager.temp_deck.erase(self)
	queue_free()


func start_drag():
	DominoManager.dm_dragging = true
	if returning_to_hand:
		return

	dragging = true
	Global.hand.remove_domino(self)
	drag_offset = global_position - get_global_mouse_position()
	z_index = 100
	
	if slot:
		slot.remove_chain()


func _process(_delta):
	if dragging and slot == null:
		global_position = get_global_mouse_position() + drag_offset


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
	else:
		Global.hand.add_domino(self)
		
	dragging = false

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
		Signals.play_domino_draged_sound.emit()
		BoardManager.highlight_avaiable_slots([a,b])
	else:
		return
	mouse_over_des = true
	show_description()


func _on_area_2d_mouse_exited() -> void:
	if !DominoManager.dm_dragging:
		BoardManager.disable_highlight()
	else:
		return
	mouse_over_des = false
	hide_description()


func show_description():
	if DominoManager.dm_dragging:
		return
	if dragging:
		return
	update_labels()
	
	for panel in tooltip_stack.get_children():
		if panel is TooltipPanel:
			await panel.show_tooltip(true)
	tooltip_stack.global_position = global_position - Vector2(61, 32) - Vector2(0, tooltip_stack.get_child(0).size.y)


func hide_description():
	for panel in tooltip_stack.get_children():
		if panel is TooltipPanel:
			panel.hide_tooltip()
	

func hide_description_fast():
	for panel in tooltip_stack.get_children():
		panel.hide()


func update_labels():
	await get_tree().process_frame
	
	var tooltip := ""
	var i := 0
	for tag: String in tags:
		if tag == "empty":
			continue
		if i > 0:
			tooltip += "\n"
		var count = a_types.count(tag) + b_types.count(tag)
		var count_string = "" if count == 1 else "(%s)" % str(count)
		if DominoSideVisual.type_to_tex.has(tag):
			tooltip += "[img]%s[/img]%s - %s" % [DominoSideVisual.type_to_tex[tag]["red"].resource_path, count_string, get_tooltip_for_type(tag)]
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
		
		if extra_tooltip_panel != null and extra_tooltip_panel.key == key:
			extra_tooltip_panel.queue_free()
			extra_tooltip_panel = null
		
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
			add(key, 2)
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
	if template != null:
		for key in tags:
			match key:
				"attack", "attack2", "dagger", "spear":
					ActionManager.add(AttackAction.new(self, Global.enemy, val[key]))
				"claws":
					ActionManager.add(AttackAction.new(self, Global.enemy, val[key] + accums[key]))
					accums[key] += 4
				"corruption", "corrupted_sphere":
					ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.corruption, val[key]))
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
					ActionManager.add(ShieldStrikeAction.new(self, Global.enemy))
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
				"corrupted_stuff":
					ActionManager.add(CorruptedStuffAction.new(self, Global.enemy))
				"skull":
					ActionManager.add(SkullsAction.new(self, Global.enemy))
				"vulnerable":
					ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.vulnerable, val[key]))
				"weak":
					ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.weak, val[key]))
		
		
		#if a_type == "claws":
			#ActionManager.add(AttackAction.new(self, Global.enemy, vals[0]["claws"]))
			#vals[0]["claws"] += 4
		#if b_type == "claws":
			#ActionManager.add(AttackAction.new(self, Global.enemy, vals[1]["claws"]))
			#vals[1]["claws"] += 4

func get_tooltip_for_type(key: String) -> String:
	match key:
		"attack", "attack2":
			return TextFormatter.insert_colored_value(tr("attack_des"), final_damage(val[key]), val[key])
		"corruption":
			return TextFormatter.insert_colored_value(tr("corruption_des"), val[key], val[key])
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
			return TextFormatter.highlight_keywords(tr("dm_shield_strike_des"))
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
		"corrupted_stuff":
			var stuff_damage = DominoManager.value1_played_dominoes + DominoManager.corruption_bonus
			return TextFormatter.insert_colored_value(tr("dm_dark_staff_des"), final_corruption(stuff_damage), stuff_damage)
		"corrupted_sphere":
			return TextFormatter.insert_colored_value(tr("dm_dark_sphere_des"), final_corruption(val[key]), val[key])
		"claws":
			return TextFormatter.insert_colored_value(tr("dm_claws_des"), final_damage(val[key] + accums[key]), val[key] + accums[key])
		"skull":
			var damage_4d = DominoManager.value4_played_dominoes * 2
			return TextFormatter.insert_colored_value(tr("4value_attack_des"), final_damage(damage_4d), damage_4d)
	return ""
