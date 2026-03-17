extends Enemy


func _ready():
	location = "MushroomCaves"
	max_health = 70
	health = max_health
	
	bonus_pool = [BoardManager.e_5fury, BoardManager.e_10def]

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0


	actions = [

	{
		"func": Callable(self,"action_attack"),
		"intent": IntentState.ATTACK,
		"damage": 15,
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
		AttackAction.new(self, Global.hero, final_damage(17))
	)
	


func action_buff():

	ActionManager.add(
		BlockAction.new(self,self,10)
	)
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.fury, 3)
	)
