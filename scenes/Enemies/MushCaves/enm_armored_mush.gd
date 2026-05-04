extends Enemy


func _ready():
	location = "MushroomCaves"
	max_health = 95
	health = max_health
	
	bonus_pool = [BoardManager.e_1thorns, BoardManager.e_1thorns, BoardManager.e_10def]

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0


	actions = [

	{
		"func": Callable(self,"action_attack"),
		"intent": IntentState.ATTACK,
		"damage": 17,
		"chance": 25,
		"max_repeats": 1
	},

	{
		"func": Callable(self,"action_buff"),
		"intent": IntentState.BUFF,
		"chance": 30,
		"max_repeats": 2
	},

	{
		"func": Callable(self,"action_attack_buff"),
		"intent": IntentState.ATTACK_BUFF,
		"damage": 12,
		"chance": 45,
		"max_repeats": 1
	}

	]

	super()

	plan_next_action()

#func add_start_fight_action():
	#ActionManager.add(
		#BuffAction.new(self, self,StatusManager.evasion,10)
	#)




func action_attack():

	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(17))
	)
	

	#ActionManager.add(
		#BuffAction.new(self, self,StatusManager.fury,larvas * 2)
		#)
	#ActionManager.add(
		#HealAction.new(self, self, larvas * 5)
		#)
	#
	#larvas = 0
	#larvas = 0
	
	
	#if get_status("invincible") == null:
		#ActionManager.add(
			#BuffAction.new(self, self,StatusManager.invincible,1)
		#)
	

	#ActionManager.add(
		#DebuffAction.new(self, Global.hero, StatusManager.vulnerable, 2)
	#)


func action_buff():
	ActionManager.add(
		BlockAction.new(self, self, 15)
	)
	ActionManager.add(
		BuffAction.new(self, self, StatusManager.thorns, 2)
	)


func action_attack_buff():
	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(12))
	)
	ActionManager.add(
		BlockAction.new(self, self, 10)
	)
