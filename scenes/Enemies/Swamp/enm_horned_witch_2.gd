extends Enemy


func _ready():
	location = "CursedSwamp"
	max_health = 85
	health = max_health
	
	bonus_pool = [BoardManager.e_10dmg, BoardManager.e_5dmg, BoardManager.e_1evasion]

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0


	actions = [

	{
		"func": Callable(self,"action1"),
		"intent": IntentState.ATTACK_DEBUFF,
		"damage": 17,
		"chance": 25,
		"max_repeats": 1
	},

	{
		"func": Callable(self,"action2"),
		"intent": IntentState.ATTACK_BUFF,
		"damage": 13,
		"chance": 45,
		"max_repeats": 1
	}

	]

	super()

	plan_next_action()





func action1():

	ActionManager.add(
		AttackDebuffAction.new(self, Global.hero, final_damage(17), StatusManager.weak, 2)
	)



func action2():

	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(13))
	)
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.fury,3)
	)
	
	if bonus_pool.size() < 7:
		bonus_pool.append(BoardManager.e_5dmg)
		bonus_pool.append(BoardManager.e_5dmg)
