extends Enemy


func _ready():
	location = "CursedSwamp"
	max_health = 100
	health = max_health
	
	bonus_pool = [BoardManager.e_15dmg]

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0


	actions = [

	{
		"func": Callable(self,"action_attack"),
		"intent": IntentState.ATTACK_BUFF,
		"damage": 15,
		"chance": 25,
		"max_repeats": 1
	},

	]

	super()

	plan_next_action()



func action_attack():

	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(15))
	)
	
	bonus_pool.append(BoardManager.e_15dmg)
