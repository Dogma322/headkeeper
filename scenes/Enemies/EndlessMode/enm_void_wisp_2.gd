extends Enemy


func _ready():
	location = "CursedSwamp"
	max_health = 100 + ((CombatManager.stage - 10) * 25)
	health = max_health
	
	bonus_pool = [BoardManager.e_void, BoardManager.e_void, BoardManager.e_15dmg]

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0


	actions = [

	{
		"func": Callable(self,"action1"),
		"intent": IntentState.ATTACK,
		"damage": 16 + ((CombatManager.stage - 10) * 3),
		"chance": 25,
		"max_repeats": 1
	},

	{
		"func": Callable(self,"action2"),
		"intent": IntentState.ATTACK_BUFF,
		"damage": 10 + ((CombatManager.stage - 10) * 2),
		"chance": 45,
		"max_repeats": 1
	}

	]

	super()

	plan_next_action()



func action1():

	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(16 + ((CombatManager.stage - 10) * 3)))
	)
	



func action2():

	ActionManager.add(
		AttackAction.new(self,Global.hero,final_damage(10 + ((CombatManager.stage - 10) * 2)))
	)
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.fury,6 + ((CombatManager.stage - 10) * 2))
	)
