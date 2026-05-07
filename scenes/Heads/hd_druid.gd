extends Head

func _ready() -> void:
	Signals.hero_healed.connect(add_action)
	super()


func update_desc() -> void:
	if invert_logic:
		description = TextFormatter.highlight_keywords(tr("hd_druid_des_elite"))
	else:
		description = TextFormatter.highlight_keywords(tr("hd_druid_des") % 20)


func apply_passive_effect() -> void:
	ActionManager.add(ChangeMaxHpAction.new(self, Global.hero, -20 if invert_logic else 20))
	ActionManager.play_one_action()


func add_action() -> void:
	if invert_logic:
		ActionManager.add(BuffAction.new(self, Global.enemy, StatusManager.fury, 1))
	else:
		ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.fury, 2))
