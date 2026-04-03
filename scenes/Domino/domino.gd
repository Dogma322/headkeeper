class_name Domino
extends Node2D
#SSS
@export_range(1, 4) var a:int
@export_range(1, 4) var b:int

var a_type: String
var b_type: String

@export_range(1, 4) var a_empty_slots := 1
@export_range(1, 4) var b_empty_slots := 1

var a_color: String:
	set(value):
		a_color = value
		top.modulate = DominoTemplate.color_to_modulate[a_color]
var b_color: String:
	set(value):
		b_color = value
		bottom.modulate = DominoTemplate.color_to_modulate[b_color]

@export var template: DominoTemplate = null

var target_position:Vector2

var slot:DominoSlot = null
var connected_side := 1
var initial_connected_side := 1

var dragging := false
var returning_to_hand = false
var drag_offset := Vector2.ZERO

var domino_types = ["Attack"]

var damage := 0
var block := 0
var heal := 0
var corruption := 0
var vulnerable := 0
var weak := 0
var draw_param := 0
var fury := 0
var thorns := 0
var val := {}
var tags := []

var vals := [{}, {}]
var buffered_values := [0, 0]

var doubled = false

var mouse_over_des = false

var domino_choice = false
var deleted = false

@onready var top_empty_slots: Sprite2D = $Visual/TopEmptySlots
@onready var top_icons: Sprite2D  = $Visual/TopIcons
@onready var bot_empty_slots: Sprite2D = $Visual/BotEmptySlots
@onready var bot_icons: Sprite2D  = $Visual/BotIcons
@onready var empty_slots_icons: Array[Sprite2D] = [top_empty_slots, bot_empty_slots]
@onready var icons: Array[Sprite2D] = [top_icons, bot_icons]
@onready var aim_marker = $AimMarker
@onready var top: Sprite2D = $Visual/Top
@onready var bottom: Sprite2D = $Visual/Bottom

@onready var dm_name: String
@onready var description: String = ""
@onready var tooltip_stack: HBoxContainer = %TooltipStack
@onready var tooltip_panel: TooltipPanel = %TooltipPanel

const ADDITIONAL_TOOLTIP_PANEL = preload("uid://dnje7ugtetwov")
var extra_tooltip_panel: AdditionalTooltipPanel = null

func set_additional_tooltip(type: String) -> void:
	if extra_tooltip_panel == null:
		extra_tooltip_panel = ADDITIONAL_TOOLTIP_PANEL.instantiate()
		extra_tooltip_panel.type = type
		tooltip_stack.add_child(extra_tooltip_panel)
	else:
		extra_tooltip_panel.type = type

class SideSettings:
	var value: int
	var type: String
	var color: String
	var empty_slots: int
	
	func _init(_value, _type = "", _empty_slots = 0, _color = ""):
		value = _value
		type = _type
		empty_slots = _empty_slots
		color = _color


func setup(a_settings: SideSettings = null, b_settings: SideSettings = null) -> void:
	if a_settings != null:
		if a_settings.value != 0:
			a = a_settings.value
		if a_settings.type != "":
			a_type = a_settings.type
		a_empty_slots = a_settings.empty_slots
		if a_settings.color == "":
			a_color = DominoTemplate.type_to_color[a_type]
		else:
			a_color = a_settings.color
	
	if b_settings != null:
		if b_settings.value != 0:
			b = b_settings.value
		if b_settings.type != "":
			b_type = b_settings.type
		b_empty_slots = b_settings.empty_slots
		if b_settings.color == "":
			b_color = DominoTemplate.type_to_color[b_type]
		else:
			b_color = b_settings.color
	
	if a_settings != null:
		var types = DominoTemplate.type_to_string
		@warning_ignore("incompatible_ternary")
		var key = a_settings.type
		if types.has(key):
			for domino_type in types[key]:
				if domino_type in domino_types:
					continue
				domino_types.push_back(domino_type)
	
	if b_settings != null:
		var types = DominoTemplate.type_to_string
		@warning_ignore("incompatible_ternary")
		var key = b_settings.type
		if types.has(key):
			for domino_type in types[key]:
				if domino_type in domino_types:
					continue
				domino_types.push_back(domino_type)
	
	if a_settings != null:
		parse_template_type(0, a_settings.type, a_settings.value)
	if b_settings != null:
		parse_template_type(1, b_settings.type, b_settings.value)
	

func _ready() -> void:
	if template != null:
		domino_types.clear()
		setup(SideSettings.new(template.a, template.a_type), SideSettings.new(template.b, template.b_type))
	
	#update_labels()
	hide_des_fast()


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


func final_heal(heal):
	return heal


func final_corruption(corruption):
	return corruption


func get_open_value():

	if connected_side == 0:
		return b

	if connected_side == 1:
		return a

	return null


func final_block(block):
	return ActionManager.calculate_block(block)


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
	tooltip_stack.global_position = global_position - Vector2(61, 81)

	if top_icons and bot_icons:
		top_icons.rotation_degrees = -rotation_degrees
		bot_icons.rotation_degrees = -rotation_degrees
		
	

func rotate_to_match(required_value:int, dir:int):

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

	if top_icons and bot_icons:
		top_icons.rotation_degrees = -rotation_degrees
		bot_icons.rotation_degrees = -rotation_degrees


func reset_rotation():
	var angle = 0
	if connected_side == 0:
		angle = 180
	# Сбрасываем основное вращение домино
	rotation_degrees = angle
	# Сбрасываем вращение иконок
	if top_icons:
		top_icons.rotation_degrees = angle
	if bot_icons:
		bot_icons.rotation_degrees = angle


func rotate_by_slot(connect_from:int, flow:int, connected_side:int):

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
	if top_icons and bot_icons:
		top_icons.rotation_degrees = -rotation_degrees
		bot_icons.rotation_degrees = -rotation_degrees


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
				hide_des_fast()
		
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
					#Hand.add_domino(self)
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
	Hand.remove_domino(self)
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
		target_slot.place_domino(self)
	else:
		Hand.add_domino(self)
		
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
		Hand.global_position + pos,
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
	if slot:
		return
		
	if !DominoManager.dm_dragging:
		Signals.play_domino_draged_sound.emit()
		
	BoardManager.highlight_avaiable_slots([a,b])
	mouse_over_des = true
	show_des()


func _on_area_2d_mouse_exited() -> void:
	BoardManager.disable_highlight()
	mouse_over_des = false
	hide_des()


func show_des():
	if DominoManager.dm_dragging:
		return
	if dragging:
		return
	update_labels()
	tooltip_stack.global_position = global_position - Vector2(61, 81)
	for panel in tooltip_stack.get_children():
		if panel is TooltipPanel:
			panel.show_tooltip(true)


func hide_des():
	for panel in tooltip_stack.get_children():
		if panel is TooltipPanel:
			panel.hide_tooltip()


func hide_des_fast():
	for panel in tooltip_stack.get_children():
		panel.hide()


func update_labels():
	await get_tree().process_frame
	if template != null:
		var tooltip = get_tooltip_for_type(template.a_type)
		if template.a_type != template.b_type:
			var tooltip2 = get_tooltip_for_type(template.b_type)
			if not tooltip2.is_empty():
				tooltip += " "
				tooltip += tooltip2
		tooltip_panel.description = tooltip
		pass
	else:
		tooltip_panel.description = ""

func add_to_special_val(type: String, value: int):
	if val.has(type):
		val[type] += value
	else:
		val[type] = value

func parse_template_type(index: int, key: String, value: int):
	if not tags.has(key):
		tags.push_back(key)
	match key:
		"attack":
			damage += value
		"attack2":
			damage += value * 2
		"defense":
			block += value
		"heal":
			heal += value
		"draw":
			draw_param += value
		"corruption":
			corruption += value
			set_additional_tooltip("Corruption")
		"vulnerable":
			vulnerable += value
			set_additional_tooltip("Vulnerable")
		"weak":
			weak += value
			set_additional_tooltip("Weak")
		"fury":
			fury += value
			set_additional_tooltip("Fury")
		"thorns":
			thorns += value
			set_additional_tooltip("Thorns")
		"spear":
			damage += value * 3
			if not Signals.attack_dm_played.is_connected(play):
				Signals.attack_dm_played.connect(play)
		"thorned_shield":
			block += value * 2
			if not Signals._2dm_played.is_connected(play):
				Signals._2dm_played.connect(play)
		"shield_strike":
			block += value * 2
		"shield":
			block += value * 3
			if not Signals.defense_dm_played.is_connected(play):
				Signals.defense_dm_played.connect(play)
		"repeat":
			add_to_special_val(key, value)
		"mace":
			add_to_special_val(key, value * 3)
		"horn":
			add_to_special_val(key, value)
			if not Signals._3dm_played.is_connected(play):
				Signals._3dm_played.connect(play)
		"crit":
			add_to_special_val(key, value)
		"dagger":
			add_to_special_val(key, value * 8)
			if not Signals.hero_healed.is_connected(play):
				Signals.hero_healed.connect(play.bind(null))
		"corrupted_stuff":
			pass
		"corrupted_sphere":
			corruption += value * 2
			if not Signals.skill_dm_played.is_connected(play):
				Signals.skill_dm_played.connect(play)
		"claws":
			buffered_values[index] = value * 4
			add_to_special_val(key, value * 4)
			if not Signals.fight_started.is_connected(on_fight_started):
				Signals.fight_started.connect(on_fight_started.bind(key))
		
	if DominoTemplate.type_to_tex.has(key):
		var textures = DominoTemplate.type_to_tex[key]
		if textures.has(value):
			icons[index].texture = textures[value]
	
	var empty_slots = a_empty_slots if index == 0 else b_empty_slots
	if empty_slots > 0 and empty_slots <= 4:
		empty_slots_icons[index].texture = DominoTemplate.slot_to_tex[empty_slots]
	else:
		empty_slots_icons[index].texture = null

func on_fight_started(key: String):
	if a_type == "claws":
		vals[0][key] = buffered_values[0]
	if b_type == "claws":
		vals[1][key] = buffered_values[1]

func play(domino: Domino):
	if domino == self:
		return
	if slot:
		add_action()

func add_action() -> void:
	if template != null:
		if damage > 0:
			ActionManager.add(AttackAction.new(self, Global.enemy, damage))
		if block > 0:
			ActionManager.add(BlockAction.new(self, Global.hero, block))
		if heal > 0:
			ActionManager.add(HealAction.new(self, Global.hero, heal))
		if fury > 0:
			ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.fury, fury))
		if thorns > 0:
			ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.thorns, thorns))
		if draw_param > 0:
			ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.draw, draw_param))
		if corruption > 0:
			ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.corruption, corruption))
		if vulnerable > 0:
			ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.vulnerable, vulnerable))
		if weak > 0:
			ActionManager.add(DebuffAction.new(self, Global.enemy, StatusManager.weak, weak))
		
		for key in tags:
			match key:
				"thorned_shield":
					ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.thorns, block))
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
				"dagger":
					ActionManager.add(AttackAction.new(self, Global.enemy, val[key]))
				"corrupted_stuff":
					ActionManager.add(CorruptedStuffAction.new(self, Global.enemy))
				"skull_4x":
					ActionManager.add(SkullsAction.new(self, Global.enemy))
		
		if a_type == "claws":
			ActionManager.add(AttackAction.new(self, Global.enemy, vals[0]["claws"]))
			vals[0]["claws"] += 4
		if b_type == "claws":
			ActionManager.add(AttackAction.new(self, Global.enemy, vals[1]["claws"]))
			vals[1]["claws"] += 4

func get_tooltip_for_type(key: String) -> String:
	
	
	match key:
		"attack", "attack2":
			return TextFormatter.insert_colored_value(tr("attack_des"), final_damage(damage), damage)
		"defense":
			return TextFormatter.insert_colored_value(tr("defense_des"), final_block(block), block)
		"heal":
			return TextFormatter.highlight_keywords(tr("heal_des") % heal)
		"corruption":
			return TextFormatter.insert_colored_value(tr("corruption_des"), corruption, corruption) 
		"vulnerable":
			return TextFormatter.highlight_keywords(tr("vulnerable_des") % vulnerable)
		"weak":
			return TextFormatter.highlight_keywords(tr("weak_des") % weak)
		"draw":
			match draw_param:
				1:
					return tr("draw_1_des")
		"fury":
			return TextFormatter.highlight_keywords(tr("strength_des") % fury)
		"thorns":
			return TextFormatter.highlight_keywords(tr("thorns_des") % thorns)
		"spear":
			return TextFormatter.insert_colored_value(tr("dm_spear_des"), final_damage(damage), damage)
		"thorned_shield":
			return TextFormatter.insert_colored_value(tr("dm_thorned_shield_des"), final_block(block), block)
		"shield_strike":
			return TextFormatter.highlight_keywords(tr("dm_shield_strike_des"))
		"shield":
			return TextFormatter.insert_colored_value(tr("dm_steel_shield_des"), final_block(block), block)
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
			return TextFormatter.insert_colored_value(tr("dm_dark_staff_des"), final_corruption(corruption), corruption)
		"corrupted_sphere":
			return TextFormatter.insert_colored_value(tr("dm_dark_sphere_des"), final_corruption(corruption), corruption)
		"claws":
			var v := 0
			if a_type == key:
				if vals[0].has(key):
					v += vals[0][key]
			if b_type == key:
				if vals[1].has(key):
					v += vals[1][key]
			
			return TextFormatter.insert_colored_value(tr("dm_claws_des"), final_damage(v), v)
		"skull_4x":
			var damage_4d = DominoManager.value4_played_dominoes * 2
			return TextFormatter.insert_colored_value(tr("4value_attack_des"), final_damage(damage_4d), damage_4d)
	return ""
