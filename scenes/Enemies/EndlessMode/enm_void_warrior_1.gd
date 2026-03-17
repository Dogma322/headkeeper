extends Enemy


func _ready():
	location = "MushroomCaves"
	max_health = 120 + ((CombatManager.stage - 10) * 35)
	health = max_health
	
	bonus_pool = [BoardManager.e_1evasion, BoardManager.e_1evasion, BoardManager.e_void]

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0


	actions = [

	{
		"func": Callable(self,"action1"),
		"intent": IntentState.ATTACK_DEBUFF,
		"damage": 16 + ((CombatManager.stage - 10) * 3),
		"chance": 25,
		"max_repeats": 1
	},

	{
		"func": Callable(self,"action2"),
		"intent": IntentState.ATTACK_BUFF,
		"damage": 14 + ((CombatManager.stage - 10) * 2),
		"chance": 25,
		"max_repeats": 1
	},


	]

	super()

	plan_next_action()




func action1():

	ActionManager.add(
		AttackDebuffAction.new(self, Global.hero, final_damage(16 + ((CombatManager.stage - 10) * 3)), StatusManager.weak, 2)
	)



func action2():

	ActionManager.add(
		AttackAction.new(self,Global.hero,final_damage(14 + ((CombatManager.stage - 10) * 2)))
	)
	
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.fury,(2 + ((CombatManager.stage - 10) * 2)))
	)

	if bonus_pool.size() < 7:
		bonus_pool.append(BoardManager.e_1evasion)
