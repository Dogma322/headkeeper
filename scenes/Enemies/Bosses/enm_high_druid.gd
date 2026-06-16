extends Enemy


func _ready():
	location = "MushroomCaves"
	max_health = 300
	health = max_health
	
	bonus_pool = [BoardManager.n_larva, BoardManager.n_larva, BoardManager.n_larva, BoardManager.n_larva, BoardManager.n_larva,]

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0


	actions = [

	{
		"func": Callable(self,"action1"),
		"intent": IntentState.ATTACK_BUFF,
		"damage": 18,
		"chance": 25,
		"max_repeats": 1
	},

	{
		"func": Callable(self,"action2"),
		"intent": IntentState.ATTACK_DEBUFF,
		"damage": 18,
		"chance": 25,
		"max_repeats": 1
	},

	]

	super()

	plan_next_action()

func add_start_fight_action():
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.devour,1)
	)




func action1():

	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(18))
	)
	
	
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.fury,3)
	)
	



	ActionManager.add(
		BuffAction.new(self, self,StatusManager.fury,larvas * 2)
		)
	ActionManager.add(
		HealAction.new(self, self, larvas * 5)
		)
	
	larvas = 0
	
	
	#if get_status("invincible") == null:
		#ActionManager.add(
			#BuffAction.new(self, self,StatusManager.invincible,1)
		#)
	

	#ActionManager.add(
		#DebuffAction.new(self, Global.hero, StatusManager.vulnerable, 2)
	#)


func action2():

	ActionManager.add(
		AttackDebuffAction.new(self, Global.hero, final_damage(18), StatusManager.weak, 2)
	)
	
	
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.fury,larvas * 2)
		)
	ActionManager.add(
		HealAction.new(self, self, larvas * 5)
		)
	
	larvas = 0
