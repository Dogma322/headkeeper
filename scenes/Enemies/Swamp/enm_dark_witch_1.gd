extends Enemy


func _ready():
	location = "CursedSwamp"
	max_health = 20
	health = max_health
	
	bonus_pool = [BoardManager.e_10dmg, BoardManager.e_10dmg, ]

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0


	actions = [

	{
		"func": Callable(self,"action1"),
		"intent": IntentState.ATTACK,
		"damage": 15,
		"chance": 25,
		"max_repeats": 1
	},
	
	{
		"func": Callable(self,"action2"),
		"intent": IntentState.ATTACK_BUFF,
		"damage": 12,
		"chance": 25,
		"max_repeats": 1
	},



	]

	super()

	plan_next_action()

func add_start_fight_action():
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.evasion,5)
	)




func action1():

	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(15))
	)
	


func action2():

	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(12))
	)
	
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.evasion,2)
	)
