extends Enemy


func _ready():
	location = "MushroomCaves"
	max_health = 60
	health = max_health
	
	bonus_pool = [BoardManager.n_remove_armor, BoardManager.e_1thorns, BoardManager.e_1thorns,]

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0


	actions = [

	{
		"func": Callable(self,"action_attack"),
		"intent": IntentState.ATTACK_BUFF,
		"damage": 10,
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
		BlockAction.new(self,self,30)
	)



func action_attack():

	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(10))
	)
	
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.thorns,1)
	)
	ActionManager.add(
		BlockAction.new(self,self,30)
	)
