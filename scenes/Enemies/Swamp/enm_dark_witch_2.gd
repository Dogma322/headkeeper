extends Enemy


func _ready():
	location = "CursedSwamp"
	max_health = 40
	health = max_health
	
	bonus_pool = [BoardManager.e_15dmg, BoardManager.e_10dmg, ]

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0


	actions = [

	{
		"func": Callable(self,"action1"),
		"intent": IntentState.ATTACK,
		"damage": 18,
		"chance": 25,
		"max_repeats": 1
	},
	
	{
		"func": Callable(self,"action2"),
		"intent": IntentState.ATTACK_BUFF,
		"damage": 14,
		"chance": 25,
		"max_repeats": 1
	},



	]

	super()

	plan_next_action()

func add_start_fight_action():
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.evasion,8)
	)




func action1():

	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(18))
	)
	


func action2():

	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(14))
	)
	
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.evasion,3)
	)
