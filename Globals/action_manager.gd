extends Node

var queue:Array[Action] = []
var running := false



func _ready() -> void:
	Signals.play_dominoes.connect(play_actions)

func calculate_damage(source, target, damage):
	
	var final_damage

	if source != Global.enemy:
		final_damage = int(ceil(((damage + Global.hero.bonus_damage) * Global.hero.damage_mult) * Global.enemy.incoming_damage_mult))
		
		
		if source is Domino:
			var crit = get_status(Global.hero, "crit")
			if crit:
				final_damage *= 2
			#####################
			
		
	if source == Global.enemy:
		final_damage = int(ceil(((damage + Global.enemy.bonus_damage) * Global.enemy.damage_mult) * Global.hero.incoming_damage_mult))

	return final_damage
	
func final_calculate_damage(source, target, damage):

	var final_damage

	if source != Global.enemy:
		final_damage = int(ceil(((damage + Global.hero.bonus_damage) * Global.hero.damage_mult) * Global.enemy.incoming_damage_mult))
		
		if source is Domino:
			var crit = get_status(Global.hero, "crit")
			if crit:
				final_damage *= 2
				crit.stacks -= 1
		
		
	if source == Global.enemy:
		final_damage = int(ceil(((damage + Global.enemy.bonus_damage) * Global.enemy.damage_mult) * Global.hero.incoming_damage_mult))

	return final_damage
		
		
func get_status(target, status_id:String):
	for icon in target.status_container.get_children():
		if icon.status.id == status_id:
			return icon.status
	return null
		
		
func calculate_block(block):
	return block
	
	

func add(action:Action):
	queue.append(action)
	
	if action is HealAction and action.target == Global.hero:
		Signals.hero_healed.emit()


func insert_next(action:Action):
	queue.push_front(action)


func insert_many(actions:Array):

	for i in range(actions.size() - 1, -1, -1):
		queue.push_front(actions[i])


func play_actions():
	print("PLAY_ACTIONS")
	if running:
		return

	running = true

	while queue.size() > 0:
		
		var action:Action = queue.pop_front()
		
		##################
		var repeat_status = get_status(Global.hero, "repeat")

		if repeat_status and action.source is Domino and action.source.doubled:
			action.source.doubled = false
			repeat_status.stacks -= 1
		####################
		
		
		if action.source != action.target:
			if action.source is Domino or action.source is BoardBonus or action.source is Head:
				action.source.play_anim()
				
				if action is not NothingAction:
					AnimationManager.spawn_proj(action.source.aim_marker.global_position, action.target.aim_marker.global_position, action)
					await Signals.projectile_hit
				
		action.execute()
		
		
		
		await get_tree().create_timer(0.35).timeout
		
		if Global.enemy.is_dead:
			running = false
			queue.clear()
			
		if Global.hero.is_dead:
			running = false
			queue.clear()

	running = false
	
	Signals.actions_completed.emit()
	
func play_one_action():
	var action = queue.pop_front()
	action.execute()


func wait(time:float):
	await get_tree().create_timer(time).timeout
