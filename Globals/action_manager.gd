extends Node

var queue:Array[Action] = []
var running := false



func _ready() -> void:
	Signals.play_dominoes.connect(play_actions)

func calculate_damage(source, target, damage):
	if source != Global.enemy:
		var final_damage = ceil(((damage + Global.hero.bonus_damage) * Global.hero.damage_mult) * Global.enemy.incoming_damage_mult)
		print("income")
		print(Global.enemy.incoming_damage_mult)
		return final_damage
	if source == Global.enemy:
		var final_damage = ceil(((damage + Global.enemy.bonus_damage) * Global.enemy.damage_mult) * Global.hero.incoming_damage_mult)
		return final_damage
	

func add(action:Action):
	queue.append(action)


func insert_next(action:Action):
	queue.push_front(action)


func insert_many(actions:Array):

	for i in range(actions.size() - 1, -1, -1):
		queue.push_front(actions[i])


func play_actions():
	if running:
		return

	running = true

	while queue.size() > 0:
		
		if Global.enemy.is_dead:
			return

		var action:Action = queue.pop_front()
		print(action)
		if action.source != action.target:
			if action.source is Domino or action.source is BoardBonus or action.source is Head:
				action.source.play_anim()
			#if action is AttackAction:
				AnimationManager.spawn_proj(action.source.aim_marker.global_position, action.target.aim_marker.global_position)
				await Signals.projectile_hit
		action.execute()
		await get_tree().create_timer(0.4).timeout

	running = false
	
	Signals.actions_completed.emit()


func wait(time:float):
	await get_tree().create_timer(time).timeout
