extends Enemy


func _ready():
	location = "MutatingForest"
	max_health = 130
	health = max_health
	
	bonus_pool = [BoardManager.e_15heal, BoardManager.e_10fury, BoardManager.e_5fury]

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0


	actions = [

	{
		"func": Callable(self,"action1"),
		"intent": IntentState.ATTACK,
		"damage": 20,
		"chance": 25,
		"max_repeats": 1
	},

	{
		"func": Callable(self,"action2"),
		"intent": IntentState.ATTACK_BUFF,
		"damage": 16,
		"chance": 25,
		"max_repeats": 1
	},


	]

	super()

	plan_next_action()

#func add_start_fight_action():
	#ActionManager.add(
		#BuffAction.new(self, self,StatusManager.evasion,10)
	#)




func action1():

	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(20))
	)
	


func action2():
	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(16))
	)

	ActionManager.add(
		HealAction.new(self, self, 15)
		)

	ActionManager.add(
		BuffAction.new(self, self,StatusManager.fury,6)
	)
