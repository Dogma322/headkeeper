extends Enemy


func _ready():
	location = "MutatingForest"
	board = "board14"
	max_health = 85
	health = max_health
	
	bonus_pool = [ BonusManager.neutral_bonuses.remove_5fury, BonusManager.neutral_bonuses.remove_5fury, BoardManager.e_5heal]

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0

	actions = [
		{
			"func": Callable(self,"action_attack_buff"),
			"intent": IntentState.ATTACK_BUFF,
			"damage": 23,
			"chance": 25,
			"max_repeats": 1
		},
	]

	super()

	plan_next_action()

func action_attack_buff():
	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(23))
	)
	ActionManager.add(
		BuffAction.new(self, self, StatusManager.fury, 10)
	)
