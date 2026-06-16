extends Enemy


func _ready():
	location = "MutatingForest"
	max_health = 90
	health = max_health
	
	bonus_pool = [BoardManager.e_3fury, BoardManager.e_3fury]

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0

	actions = [
		{
			"func": Callable(self,"action_attack"),
			"intent": IntentState.ATTACK_BUFF,
			"damage": 12,
			"chance": 25,
			"max_repeats": 1
		},
		{
			"func": Callable(self,"action_attack_buff2"),
			"intent": IntentState.ATTACK_BUFF,
			"damage": 18,
			"chance": 25,
			"max_repeats": 1
		},
	]
	
	super()
	plan_next_action()


func action_attack_buff1() -> void:
	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(12))
	)
	ActionManager.add(
		BuffAction.new(self, self, StatusManager.evasion, 2)
	)

func action_attack_buff2() -> void:
	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(18))
	)
	ActionManager.add(
		BuffAction.new(self, self, StatusManager.fury, 3)
	)
