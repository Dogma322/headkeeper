extends Enemy


func _ready():
	location = "MutatingForest"
	max_health = 65
	health = max_health
	
	bonus_pool = [BoardManager.e_5heal, BoardManager.e_10heal, BoardManager.e_5heal,]

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0


	actions = [

	{
		"func": Callable(self,"action_attack"),
		"intent": IntentState.ATTACK_BUFF,
		"damage": 15,
		"chance": 25,
		"max_repeats": 1
	},

	]

	super()

	plan_next_action()



func action_attack():

	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(15))
	)
	
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.fury,1)
	)
