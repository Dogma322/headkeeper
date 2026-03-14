extends Enemy


func _ready():

	max_health = 95
	health = max_health

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0


	actions = [

	{
		"func": Callable(self,"action_attack"),
		"intent": IntentState.ATTACK,
		"damage": 17,
		"chance": 25,
		"max_repeats": 1
	},

	{
		"func": Callable(self,"action_buff"),
		"intent": IntentState.BUFF,
		"chance": 30,
		"max_repeats": 2
	},

	{
		"func": Callable(self,"action_attack_buff"),
		"intent": IntentState.ATTACK_BUFF,
		"damage": 12,
		"chance": 45,
		"max_repeats": 1
	}

	]

	super()

	plan_next_action()



func action_attack():

	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(17))
	)
	#ActionManager.add(
		#DebuffAction.new(self, Global.hero, StatusManager.vulnerable, 2)
	#)


func action_buff():

	ActionManager.add(
		BlockAction.new(self,self,15)
	)
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.thorns,2)
	)





func action_attack_buff():

	ActionManager.add(
		AttackAction.new(self,Global.hero,final_damage(12))
	)
	
	ActionManager.add(
		BlockAction.new(self,self,12)
	)
