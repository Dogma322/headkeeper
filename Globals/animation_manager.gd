extends Node

var ricochet_counter = 0

var proj = preload("res://scenes/Projectiles/projectile_template.tscn")

var damage_label = preload("res://scenes/GeneratedLabels/damage_label.tscn")
var heal_label = preload("res://scenes/GeneratedLabels/heal_label.tscn")
var status_label = preload("res://scenes/GeneratedLabels/status_label.tscn")
var block_label = preload("res://scenes/GeneratedLabels/block_damage_label.tscn")

var attack_anim = preload("res://scenes/Animations/attack_anim.tscn")
var heal_anim = preload("res://scenes/Animations/heal_anim.tscn")
var armor_anim = preload("res://scenes/Animations/armor_anim.tscn")
var buff_anim = preload("res://scenes/Animations/buff_animation.tscn")
var debuff_anim = preload("res://scenes/Animations/debuff_animation.tscn")
var corruption_attack = preload("res://scenes/Animations/corruption_attack_anim.tscn")


func _ready() -> void:
	#Signals.discard_all_bullets_anim.connect(spawn_discard_all_bullets_anim)
	pass

# Called when the node enters the scene tree for the first time.
func spawn_anim(scene: PackedScene, target, damage):
	var anim = scene.instantiate()
	Global.fight_scene.add_child(anim)
	anim.global_position = get_pos(target)
	
	if scene == heal_anim:
		spawn_heal_label(damage, target)
	#if scene == attack_anim:
		#spawn_damage_label(damage, target)
	
	
	await get_tree().create_timer(0.5).timeout

	
func spawn_proj(attacker_pos,target_pos, action):
	var bullet = proj.instantiate()
	Global.fight_scene.add_child(bullet)
	bullet.set_proj(action)
	bullet.fly(attacker_pos, target_pos)
	
	
#func spawn_proj(attacker_pos,target_pos, on_hit):
	#var bullet = bullet_proj.instantiate()
	#Global.fight_scene.add_child(bullet)
	#bullet.fly(attacker_pos, target_pos, on_hit)
	
	
	
func spawn_damage_label(damage, target):
	var dmg_label = damage_label.instantiate()
	dmg_label.damage = damage
	Global.fight_scene.add_child(dmg_label)
	dmg_label.global_position = get_pos(target)
	dmg_label.animate()
	
	
	
func spawn_heal_label(damage, target):
	var label = heal_label.instantiate()
	label.heal = damage
	Global.fight_scene.add_child(label)
	label.global_position = get_pos(target)
	label.animate()
	
	
	
func spawn_status_label(target, status_name, stacks):
	var label = status_label.instantiate()
	label.status_name = status_name
	label.stacks = stacks
	Global.fight_scene.add_child(label)
	label.global_position = target.aim_marker.global_position
	label.animate()
	
func spawn_block_label(target):
	var label = block_label.instantiate()
	Global.fight_scene.add_child(label)
	label.global_position = target.aim_marker.global_position
	label.animate()
	
	

	
func get_pos(target):
	return target.aim_marker.global_position
	
		
	




	
