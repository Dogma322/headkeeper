extends Enemy


func _ready():
	location = "CursedSwamp"
	max_health = 60
	health = max_health
	
	bonus_pool = [BoardManager.e_decrease_5_max_hp, BoardManager.e_5dmg, BoardManager.e_5dmg]

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0


	actions = [

	{
		"func": Callable(self,"action1"),
		"intent": IntentState.ATTACK_DEBUFF,
		"damage": 12,
		"chance": 25,
		"max_repeats": 1
	},

	{
		"func": Callable(self,"action2"),
		"intent": IntentState.BUFF,
		"chance": 30,
		"max_repeats": 2
	},

	{
		"func": Callable(self,"action3"),
		"intent": IntentState.ATTACK,
		"damage": 15,
		"chance": 25,
		"max_repeats": 1
	},

	]

	super()

	plan_next_action()



func action1():

	ActionManager.add(
		AttackDebuffAction.new(self, Global.hero, final_damage(12), StatusManager.weak, 2)
	)
	



func action2():

	ActionManager.add(
		BuffAction.new(self, self,StatusManager.fury,3)
	)



func action3():

	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(15))
	)
