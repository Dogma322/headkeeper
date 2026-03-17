extends Enemy


func _ready():
	location = "CursedSwamp"
	max_health = 60
	health = max_health
	
	bonus_pool = [BoardManager.e_2vulnerable, BoardManager.e_2vulnerable, BoardManager.n_remove_invincible]

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0


	actions = [

	{
		"func": Callable(self,"action1"),
		"intent": IntentState.ATTACK_BUFF,
		"damage": 14,
		"chance": 25,
		"max_repeats": 1
	},


	]

	super()

	plan_next_action()

func add_start_fight_action():
	ActionManager.add(
		BuffAction.new(self, self,StatusManager.invincible,1)
	)




func action1():

	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(14))
	)
	
	
	if get_status("invincible") == null:
		ActionManager.add(
			BuffAction.new(self, self,StatusManager.invincible,1)
		)
	
