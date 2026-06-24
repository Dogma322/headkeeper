extends Enemy

## Шаблон врага : Псарь.

func _ready() -> void:
	location = "MutatingForest"
	board = "board15"
	max_health = 85
	health = max_health
	
	bonus_pool = [BoardManager.e_10dmg, BoardManager.e_10dmg]
	actions = [
		{
			"func": Callable(self,"action_attack"),
			"intent": IntentState.ATTACK_DEBUFF,
			"damage": 13,
			"chance": 25,
			"max_repeats": 1
		},
		{
			"func": Callable(self,"action_buff"),
			"intent": IntentState.BUFF,
			"chance": 30,
			"max_repeats": 2
		},
	]
	
	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0
	
	super()
	plan_next_action()


func action_attack() -> void:
	ActionManager.add(
		AttackDebuffAction.new(self, Global.hero, final_damage(13), StatusManager.weak, 2)
	)


func action_buff() -> void:
	ActionManager.add(
		HealAction.new(self, self, 8)
	)
	if bonus_pool.size() < 6:
		bonus_pool.append(BoardManager.e_10dmg)
