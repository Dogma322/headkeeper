extends BoardBonus

func _ready() -> void:
	super()
	Signals.player_turn_end.connect(increase_larvas)
	
func increase_larvas():
	Global.enemy.larvas += 1

func add_action():
	ActionManager.add(NothingAction.new(self, Global.hero, 0))
	
func update_labels():
	tooltip_panel.caption = tr("bn_larva_name")
	tooltip_panel.description = TextFormatter.highlight_keywords(tr("bn_larva_des"))
