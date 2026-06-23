extends Enemy


func _ready() -> void:
	location = "MutatingForest"
	board = "board10"
	max_health = 55
	health = max_health
	
	bonus_pool = [BoardManager.e_5heal]
	
	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0
	
	actions = [
		{
			"func": Callable(self,"action_attack"),
			"intent": IntentState.ATTACK,
			"damage": 9,
			"chance": 25,
			"max_repeats": 1
		},
	]

	super()
	plan_next_action()


func action_attack() -> void:
	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(9))
	)
