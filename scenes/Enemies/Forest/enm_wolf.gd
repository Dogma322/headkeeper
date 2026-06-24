extends Enemy

## Шаблон врага: Волк.

func _ready() -> void:
	location = "MutatingForest"
	board = "board9"
	max_health = 110
	health = max_health
	
	#region Фаза 1
	
	bonus_pool = [BoardManager.e_3fury, BoardManager.e_1evasion, BoardManager.e_1evasion]
	actions = [
		{
			"func": Callable(self, "action_attack"),
			"intent": IntentState.ATTACK,
			"damage": 18,
			"chance": 25,
			"max_repeats": 1
		},
	]
	
	#endregion
	
	#region Фаза 2
	
	has_phase2 = true
	phase2_hp_threshold = 45
	
	bonus_pool2 = [BoardManager.e_5fury, BoardManager.e_5fury, BoardManager.e_5heal, BoardManager.e_5heal]
	actions2 = [
		{
			"func": Callable(self, "action_attack_buff_phase2"),
			"intent": IntentState.ATTACK_BUFF,
			"damage": 18,
			"chance": 25,
			"max_repeats": 1
		},
	]
	
	#endregion
	
	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0
	
	super()
	plan_next_action()


func action_attack() -> void:
	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(18))
	)


func action_attack_buff_phase2() -> void:
	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(18))
	)
	ActionManager.add(
		BuffAction.new(self, self, StatusManager.fury, 10)
	)
	ActionManager.add(
		HealAction.new(self, self, 5)
	)
