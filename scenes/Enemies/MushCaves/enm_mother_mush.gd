extends Enemy


func _ready():
	location = "MutatingForest"
	max_health = 45
	health = max_health
	
	bonus_pool = [BoardManager.n_remove_armor, BoardManager.e_1thorns, ]

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0


	actions = [

	{
		"func": Callable(self,"action_attack"),
		"intent": IntentState.ATTACK_BUFF,
		"damage": 8,
		"chance": 25,
		"max_repeats": 1
	},

	]

	super()

	plan_next_action()

func add_start_fight_action():
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.thorns,2)
	)
	ActionManager.add(
		BlockAction.new(self,self,15)
	)



func action_attack():

	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(8))
	)
	
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.thorns,1)
	)
	ActionManager.add(
		BlockAction.new(self,self,15)
	)
