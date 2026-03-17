extends Enemy


func _ready():
	location = "MushroomCaves"
	max_health = 140
	health = max_health
	
	bonus_pool = [BoardManager.n_remove_10fury, BoardManager.e_15def, BoardManager.e_15def,]

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0


	actions = [

	{
		"func": Callable(self,"action1"),
		"intent": IntentState.ATTACK,
		"damage": 35,
		"chance": 25,
		"max_repeats": 1
	},

	{
		"func": Callable(self,"action2"),
		"intent": IntentState.ATTACK_BUFF,
		"damage": 35,
		"chance": 25,
		"max_repeats": 1
	},


	]

	super()

	plan_next_action()



func action1():

	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(35))
	)
	


func action2():
	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(35))
	)

	ActionManager.add(
		BlockAction.new(self, self, 10)
		)

	ActionManager.add(
		BuffAction.new(self, self,StatusManager.fury,15)
	)
