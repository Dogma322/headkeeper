extends Enemy

func _ready():
	location = "MutatingForest"
	board = "board11"
	max_health = 35
	health = max_health
	
	bonus_pool = [BoardManager.e_5heal]
	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0

	actions = [
		{
			"func": Callable(self,"action_attack"),
			"intent": IntentState.ATTACK,
			"damage": 12,
			"chance": 25,
			"max_repeats": 1
		},

		{
			"func": Callable(self,"action_buff"),
			"intent": IntentState.BUFF,
			"chance": 30,
			"max_repeats": 1
		},
	]
	
	super()
	plan_next_action()


func action_attack() -> void:
	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(12))
	)


func action_buff() -> void:
	ActionManager.add(
		BuffAction.new(self, self, StatusManager.fury, 4)
	)
	ActionManager.add(
		HealAction.new(self, self, 4)
	)
