extends Enemy


func _ready():
	location = "MushroomCaves"
	max_health = 60
	health = max_health
	
	bonus_pool = [BoardManager.e_10def, BoardManager.n_remove_5fury]

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0


	actions = [

	{
		"func": Callable(self,"action_attack"),
		"intent": IntentState.ATTACK,
		"damage": 10,
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

func add_start_fight_action():
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.fury,10)
	)




func action_attack():

	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(10))
	)
	


func action_buff():

	ActionManager.add(
		BlockAction.new(self,self,10)
	)
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.fury,10)
	)
