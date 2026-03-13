extends Enemy


func _ready():

	max_health = 95
	health = max_health

	behavior_mode = BehaviorMode.CHANCE_BASED
	first_action_index = 0


	actions = [

	{
		"func": Callable(self,"action_attack"),
		"intent": IntentState.ATTACK,
		"damage": 14,
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
		"damage": 15,
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



func action_buff():

	ActionManager.add(
		AttackAction.new(self,Global.hero,final_damage(20))
	)





func action_attack_buff():

	ActionManager.add(
		AttackAction.new(self,Global.hero,final_damage(30))
	)
