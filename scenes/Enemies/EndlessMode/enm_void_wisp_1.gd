extends Enemy


func _ready():
	location = "MutatingForest"
	max_health = 130 + ((CombatManager.stage - 10) * 10)
	health = max_health
	
	bonus_pool = [BoardManager.e_void, BoardManager.e_15def, BoardManager.e_2thorns,]

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0


	actions = [

	{
		"func": Callable(self,"action_attack"),
		"intent": IntentState.ATTACK_BUFF,
		"damage": 16 + ((CombatManager.stage - 10) * 3),
		"chance": 25,
		"max_repeats": 1
	},

	]

	super()

	plan_next_action()

func add_start_fight_action():
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.thorns,3)
	)
	ActionManager.add(
		BlockAction.new(self, self, 6 + ((CombatManager.stage - 10) * 2))
	)



func action_attack():

	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(16 + ((CombatManager.stage - 10) * 3)))
	)
	
	ActionManager.add(
		BlockAction.new(self, self, 6 + ((CombatManager.stage - 10) * 2))
	)
