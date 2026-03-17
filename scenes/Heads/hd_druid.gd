extends Head

func _ready() -> void:
	Signals.hero_healed.connect(add_action)
	hd_name = tr("hd_druid_name") 
	description = TextFormatter.highlight_keywords(tr("hd_druid_des") % 20)
	super()
	
func apply_passive_effect():
	ActionManager.add(DecreaseMaxHpAction.new(self, Global.hero, 20))
	ActionManager.play_one_action()
	
func add_action():
	ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.fury, 2))
