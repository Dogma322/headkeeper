extends Enemy

func _ready():
	location = "MutatingForest"
	max_health = 100
	health = max_health
	
	bonus_pool = [BoardManager.e_5heal]
	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0

	actions = [
		{
			"func": Callable(self, "action1"),
			"intent": IntentState.ATTACK_DEBUFF,
			"damage": 12,
			"chance": 25,
			"max_repeats": 1
		},
		{
			"func": Callable(self, "action2"),
			"intent": IntentState.ATTACK,
			"damage": 14,
			"chance": 25,
			"max_repeats": 1
		},
		{
			"func": Callable(self, "action3"),
			"intent": IntentState.BUFF,
			"chance": 30,
			"max_repeats": 1
		},
	]
	
	super()
	plan_next_action()


func action1() -> void:
	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(12))
	)
	ActionManager.add(
		DebuffAction.new(self, Global.hero, StatusManager.weak, 3)
	)
	ActionManager.add(
		DebuffAction.new(self, Global.hero, StatusManager.vulnerable, 3)
	)


func action2() -> void:
	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(14))
	)


func action3() -> void:
	ActionManager.add(
		BuffAction.new(self, self, StatusManager.fury, 5)
	)
	ActionManager.add(
		BlockAction.new(self, self, 15)
	)
