extends Enemy


func _ready():
	location = "MutatingForest"
	max_health = 140
	health = max_health
	
	bonus_pool = [BoardManager.n_remove_5fury, BoardManager.n_remove_5fury, BoardManager.n_remove_5fury,
	BoardManager.e_10heal,BoardManager.e_10heal, BoardManager.e_10heal, BoardManager.e_10heal,]

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0


	actions = [

	{
		"func": Callable(self,"action_attack"),
		"intent": IntentState.ATTACK_BUFF,
		"damage": 35,
		"chance": 25,
		"max_repeats": 1
	},

	]

	super()

	plan_next_action()



func action_attack():

	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(35))
	)
	
	ActionManager.add(
		HealAction.new(self, self, 10)
	)
	
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.fury,10)
	)
