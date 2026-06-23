extends Enemy


func _ready():
	location = "MutatingForest"
	board = "board13"
	max_health = 100
	health = max_health
	
	has_phase2 = true
	bonus_pool2 = [BoardManager.e_5dmg, BoardManager.e_5dmg, BoardManager.e_5dmg, BoardManager.e_5dmg]
	phase2_hp_threshold = 50
	
	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0
	
	actions = [
		{
			"func": Callable(self,"action_attack"),
			"intent": IntentState.ATTACK,
			"damage": 16,
			"chance": 25,
			"max_repeats": 1
		},
	]
	
	actions2 = [
		{
			"func": Callable(self,"action_attack_phase2"),
			"intent": IntentState.ATTACK_BUFF,
			"damage": 16,
			"chance": 25,
			"max_repeats": 1
		},
	]
	
	super()
	plan_next_action()


func action_attack():
	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(16))
	)

func action_attack_phase2():
	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(16))
	)
	ActionManager.add(
		BuffAction.new(self, self, StatusManager.fury, 2)
	)
