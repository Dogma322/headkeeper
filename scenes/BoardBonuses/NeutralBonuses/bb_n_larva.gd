extends BoardBonus

func _ready() -> void:
	super()
	Signals.player_turn_end.connect(increase_larvas)
	
func increase_larvas():
	Global.enemy.larvas += 1

func add_action():
	ActionManager.add(NothingAction.new(self, Global.hero, 0))
	
func update_labels():
	name_label.text = tr("bn_larva_name")
	des_label.text = TextFormatter.highlight_keywords(tr("bn_larva_des"))
