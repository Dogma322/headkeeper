extends Enemy


func _ready():
	location = "CursedSwamp"
	max_health = 100
	health = max_health
	
	bonus_pool = [BoardManager.e_decrease_5_max_hp, BoardManager.e_decrease_5_max_hp,]

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0


	actions = [

	{
		"func": Callable(self,"action1"),
		"intent": IntentState.ATTACK_DEBUFF,
		"damage": 18,
		"chance": 25,
		"max_repeats": 1
	},

	{
		"func": Callable(self,"action2"),
		"intent": IntentState.ATTACK_BUFF,
		"damage": 14,
		"chance": 45,
		"max_repeats": 1
	}

	]

	super()

	plan_next_action()


func add_start_fight_action():
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.invincible,1)
	)


func action1():

	ActionManager.add(
		AttackDebuffAction.new(self, Global.hero, final_damage(18), StatusManager.weak, 2)
	)




	if get_status("invincible") == null:
		ActionManager.add(
			BuffAction.new(self, self,StatusManager.invincible,1)
		)


func action2():

	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(14))
	)
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.fury,4)
	)
	
	
	
	if get_status("invincible") == null:
		ActionManager.add(
			BuffAction.new(self, self,StatusManager.invincible,1)
		)
