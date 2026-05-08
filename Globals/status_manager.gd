extends Node

var vulnerable = preload("res://resources/statuses/vulnerable.tres")
var corruption = preload("res://resources/statuses/corruption.tres")
var thorns = preload("res://resources/statuses/thorns.tres")
var weak = preload("res://resources/statuses/weak.tres")
var invincible = preload("res://resources/statuses/invincible.tres")
var evasion = preload("res://resources/statuses/evasion.tres")
var draw = preload("res://resources/statuses/draw.tres")
var fury = preload("res://resources/statuses/fury.tres")
var repeat = preload("res://resources/statuses/repeat.tres")
var crit = preload("res://resources/statuses/crit.tres")
var devour = preload("res://resources/statuses/devour.tres")


#func apply_status(status, stacks, target):
#
	#var new_status = status.duplicate(true)
	#new_status.stacks = stacks
	#target.status_container.add_status(new_status, stacks)


func apply_status(status: StatusResource, stacks, target):
	target.status_container.add_status(status.duplicate(true), stacks)

func initialize_status(status: StatusResource):
	status.status_changed.connect(_on_status_changed.bind(status))
	_on_status_changed(status)
	
	if status.id == "thorns":
		if status.owner == Global.hero:
			Signals.deal_enemy_thorn_damage.connect(add_action.bind(status))
		elif status.owner == Global.enemy:
			Signals.deal_hero_thorn_damage.connect(add_action.bind(status))


func apply_status_effect(status: StatusResource):
	match status.id:
		"corruption":
			ActionManager.add(CorruptionAttackAction.new(Global.enemy, status.stacks))
		"draw":
			DominoManager.bonus_draw_counter += status.stacks
			status.stacks = 0


func _on_status_changed(status: StatusResource):
	match status.id:
		"vulnerable":
			status.owner.incoming_damage_mult = 1.5
		"fury":
			status.owner.bonus_damage = status.stacks
		"weak":
			status.owner.damage_mult = 0.75


func remove_status_effect(status: StatusResource):
	match status.id:
		"vulnerable":
			status.owner.incoming_damage_mult = 1
		"weak":
			status.owner.damage_mult = 1
		"fury":
			status.owner.bonus_damage = 0
	
	if status.id == "thorns":
		if status.owner == Global.hero:
			Signals.deal_enemy_thorn_damage.disconnect(add_action)
		elif status.owner == Global.enemy:
			Signals.deal_hero_thorn_damage.disconnect(add_action)


func add_action(status: StatusResource):
	match status.id:
		"thorns":
			var mult = 1.0
			
			var target
			if status.owner == Global.hero:
				target = Global.enemy
				mult = Global.hero.thorns_damage_mult
				
			if status.owner == Global.enemy:
				target = Global.hero
			ActionManager.insert_next(AttackWithoutAnim.new(target, status.stacks * mult))
