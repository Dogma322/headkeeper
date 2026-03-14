extends StatusResource


func initialize_status():
	#status_changed.connect(_on_status_changed)
	if owner == Global.hero:
		Signals.deal_enemy_thorn_damage.connect(add_action)
	elif owner == Global.enemy:
		Signals.deal_hero_thorn_damage.connect(add_action)

	#_on_status_changed()

#func _on_status_changed():
	#print("INIT")
	#owner.incoming_damage_mult = 1.5

func add_action():
	var target
	if owner == Global.hero:
		target = Global.enemy
		
	if owner == Global.enemy:
		target = Global.hero
	ActionManager.insert_next(AttackWithoutAnim.new(target, stacks))
