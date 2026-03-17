extends Node2D
class_name Head

@onready var head_sprite = $Sprite2D
@onready var des_panel = $DesPanel
@onready var name_label = $DesPanel/NameLabel
@onready var des_label = $DesPanel/DesLabel
@onready var aim_marker = $AimMarker
@onready var label = $Label

@onready var hd_name: String
@onready var description: String

@onready var damage = 0
@onready var armor = 0
@onready var heal = 0

#@onready var final_damage
#@onready var final_armor
#@onready var final_heal

var head_choice = false

func _ready() -> void:
	des_panel.modulate.a = 0
	label.visible = false
	
	update_labels()



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
	
func turn_begin_add_action():
	pass
	
func apply_passive_effect():
	pass
	
func remove_passive_effect():
	pass



func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and head_choice:
		if _is_mouse_over(event.position):
			head_choice = false
			get_parent().choice_selected(self)
			add_head_to_head_holder()
			Signals.head_selected.emit()
			
func add_head_to_head_holder():
	apply_passive_effect()
	get_parent().remove_child(self)
	Global.head_holder.add_child(self)
			
	
			
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
	z_index = 100
	update_labels()
	var tween = get_tree().create_tween()
	tween.tween_property(des_panel, "modulate:a", 1, 0.3)
	
func hide_des():
	update_labels()
	var tween = get_tree().create_tween()
	tween.tween_property(des_panel, "modulate:a", 0, 0.3)
	await tween.finished
	z_index = 0

func update_labels():
	#final_damage = (damage + Global.hero_strength) * Global.hero_damage_multiplier
	#final_armor = (armor + Global.hero_dexterity) * Global.hero_armor_multiplier
	#final_heal = heal
	
	name_label.text = hd_name
	des_label.text = description
