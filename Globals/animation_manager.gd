extends Node

@onready var bullet_proj = preload("res://scenes/Projectiles/projectile_template.tscn")



func spawn_proj(attacker_pos,target_pos):
	var bullet = bullet_proj.instantiate()
	Global.fight_scene.add_child(bullet)
	bullet.fly(attacker_pos, target_pos)
	
