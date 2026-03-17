extends Enemy


func _ready():
	location = "MutatingForest"
	max_health = 40
	health = max_health
	
	bonus_pool = [BoardManager.e_5dmg, BoardManager.e_5dmg]

	behavior_mode = BehaviorMode.SEQUENTIAL
	first_action_index = 0


	actions = [

	{
		"func": Callable(self,"action_attack"),
		"intent": IntentState.ATTACK,
		"damage": 12,
		"chance": 25,
		"max_repeats": 1
	},

	]

	super()

	plan_next_action()



func action_attack():

	ActionManager.add(
		AttackAction.new(self, Global.hero, final_damage(12))
	)
	

	#ActionManager.add(
		#BuffAction.new(self, self,StatusManager.fury,larvas * 2)
		#)
	#ActionManager.add(
		#HealAction.new(self, self, larvas * 5)
		#)
	#
	#larvas = 0
	
	
	#if get_status("invincible") == null:
		#ActionManager.add(
			#BuffAction.new(self, self,StatusManager.invincible,1)
		#)
	

	#ActionManager.add(
		#DebuffAction.new(self, Global.hero, StatusManager.vulnerable, 2)
	#)
