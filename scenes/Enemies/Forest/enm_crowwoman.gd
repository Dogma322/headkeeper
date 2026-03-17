extends Enemy


func _ready():
	location = "MutatingForest"
	max_health = 130
	health = max_health
	
	bonus_pool = [BoardManager.e_15heal, BoardManager.e_1evasion, BoardManager.e_1evasion, BoardManager.n_remove_5fury]

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0


	actions = [

	{
		"func": Callable(self,"action_attack"),
		"intent": IntentState.ATTACK,
		"damage": 25,
		"chance": 25,
		"max_repeats": 1
	},

	{
		"func": Callable(self,"action_buff"),
		"intent": IntentState.BUFF,
		"chance": 30,
		"max_repeats": 2
	},

	]

	super()

	plan_next_action()




func action_attack():

	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(25))
	)
	


func action_buff():
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.evasion,3)
	)
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.fury,15)
	)
