extends Node2D
class_name Head

@onready var head_sprite: Sprite2D = $Sprite2D
@onready var tooltip_stack: HBoxContainer = %TooltipStack
@onready var tooltip_panel: TooltipPanel = %TooltipPanel
@onready var aim_marker = $AimMarker
@onready var label = $Label

@export var template: HeadTemplate:
	set(value):
		template = value
		if value:
			if is_instance_valid(head_sprite):
				head_sprite.texture = template.texture
			hd_name = template.get_translated_name()
		else:
			if is_instance_valid(head_sprite):
				head_sprite.texture = null
			
@export var block_input := false

@onready var hd_name: String:
	set(value):
		hd_name = value
		if is_instance_valid(tooltip_panel):
			tooltip_panel.caption = hd_name
@onready var description: String:
	set(value):
		description = value
		if is_instance_valid(tooltip_panel):
			tooltip_panel.description = TextFormatter.highlight_keywords(value)

@onready var damage := 0
@onready var armor := 0
@onready var heal := 0
@onready var value := 1
@onready var corruption := 0

#@onready var final_damage
#@onready var final_armor
#@onready var final_heal

var key := ""
var head_choice := false
var invert_logic := false
var used := false
var level := 0:
	set(value):
		if level == value:
			return
		level = value
		used = false

func _ready() -> void:
	tooltip_stack.hide()
	label.visible = false
	
	if template:
		hd_name = template.get_translated_name()
		damage = template.damage
		armor = template.armor
		heal = template.heal
		value = template.value
		corruption = template.corruption
		head_sprite.texture = template.texture
	
	update_desc()

#func play(_domino):
	##await get_tree().create_timer(0.5).timeout
	#play_animation()
	#play_effect()


func play_anim():
	var tween = create_tween()
	tween.tween_property(head_sprite, "scale", Vector2(1.6, 1.6), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(head_sprite, "scale", Vector2(0.8, 0.8), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(head_sprite, "scale", Vector2(1, 1), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)


func add_action():
	pass


## Происходит при начале хода в начале боя.
func battle_start_add_action() -> void:
	pass


## Происходит при начале хода.
func turn_begin_add_action():
	pass


func apply_passive_effect():
	pass


func remove_passive_effect():
	pass


func update_desc() -> void:
	pass


func _input(event: InputEvent) -> void:
	if block_input:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and head_choice:
		if _is_mouse_over(event.position):
			head_choice = false
			Signals.head_selected.emit(self)


func add_head_to_head_holder():
	if get_parent() != null:
		get_parent().remove_child(self)
	Global.head_holder.add_child(self)
	Signals.head_amount_changed.emit()
	apply_passive_effect()


func _is_mouse_over(mouse_global: Vector2) -> bool:
	if head_sprite.texture == null:
		return false
	var lp: Vector2 = to_local(mouse_global)
	
	var sz: Vector2
	if head_sprite.region_enabled:
		sz = head_sprite.region_rect.size * scale
	else:
		sz = head_sprite.texture.get_size() * scale

	var rect: Rect2 = Rect2(Vector2.ZERO, sz)
	if head_sprite.centered:
		rect.position = -sz * 0.5
	return rect.has_point(lp)


func _on_des_area_mouse_entered() -> void:
	show_des()


func _on_des_area_mouse_exited() -> void:
	hide_des()


func show_des():
	if DominoManager.dm_dragging:
		return
	tooltip_stack.show()
	var size_x = 0
	for panel in tooltip_stack.get_children():
		if panel is TooltipPanel:
			panel.show_tooltip()
			size_x += panel.size.x
	if tooltip_stack.global_position.x < 0:
		tooltip_stack.global_position.x = 0
	if tooltip_stack.global_position.x + size_x > get_viewport_rect().size.x:
		tooltip_stack.global_position.x = get_viewport_rect().size.x - size_x


func hide_des():
	tooltip_stack.hide()
	for panel in tooltip_stack.get_children():
		if panel is TooltipPanel:
			panel.hide_tooltip()
	await get_tree().create_timer(0.15).timeout
