extends Enemy

## Шаблон врага : Кабан.

func _ready() -> void:
	location = "MutatingForest"
	board = "board17"
	max_health = 40
	health = max_health
	
	bonus_pool = [BoardManager.e_5dmg]
	actions = [
		{
			"func": Callable(self, "action_attack_debuff"),
			"intent": IntentState.ATTACK_DEBUFF,
			"damage": 9,
			"chance": 25,
			"max_repeats": 1
		},
		{
			"func": Callable(self,"action_attack"),
			"intent": IntentState.ATTACK,
			"damage": 13,
			"chance": 25,
			"max_repeats": 1
		},
	]
	
	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0
	
	super()
	plan_next_action()


func action_attack_debuff() -> void:
	ActionManager.add(AttackDebuffAction.new(self, Global.hero, final_damage(9), StatusManager.weak, 2))


func action_attack() -> void:
	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(13))
	)
