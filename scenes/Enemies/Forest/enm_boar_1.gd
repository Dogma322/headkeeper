extends Enemy


func _ready() -> void:
	location = "MutatingForest"
	board = "board17"
	max_health = 40
	health = max_health
	
	bonus_pool = [BoardManager.e_5dmg]
	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0
	
	actions = [
		{
			"func": Callable(self,"action1"),
			"intent": IntentState.ATTACK_DEBUFF,
			"damage": 9,
			"chance": 25,
			"max_repeats": 1
		},
		{
			"func": Callable(self,"action2"),
			"intent": IntentState.ATTACK,
			"damage": 13,
			"chance": 25,
			"max_repeats": 1
		},
	]


func action1() -> void:
	ActionManager.add(AttackDebuffAction.new(self, Global.hero, final_damage(9), StatusManager.weak, 2))


func action2() -> void:
	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(13))
	)
