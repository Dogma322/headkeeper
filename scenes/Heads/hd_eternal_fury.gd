extends Head

## Голова - Вечная Ярость.

func _ready() -> void:
	super()
	Signals.status_added.connect(_on_status_added)


func _on_status_added(status: StatusResource) -> void:
	if not invert_logic and status.id == "fury":
		match level:
			1:
				ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.fury, 1))
			2:
				ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.fury, 2))
	pass


func update_desc() -> void:
	if invert_logic:
		description = tr("HD_ETERNAL_FURY_DESC_ELITE")
	else:
		match level:
			0:
				description = tr("HD_ETERNAL_FURY_DESC")
			1:
				description = tr("HD_ETERNAL_FURY_DESC2")
			2:
				description = tr("HD_ETERNAL_FURY_DESC3")
	pass


func apply_passive_effect() -> void:
	if invert_logic:
		Global.enemy.bonus_pool.append(BoardManager.e_3fury)
	else:
		BoardManager.bonus_pool.append(BonusManager.bonus_effects.h_1fury)
		BoardManager.bonus_pool.append(BonusManager.bonus_effects.h_1fury)
	pass


func remove_passive_effect() -> void:
	if invert_logic:
		Global.enemy.bonus_pool.erase(BoardManager.e_3fury)
	else:
		BoardManager.bonus_pool.erase(BonusManager.bonus_effects.h_1fury)
		BoardManager.bonus_pool.erase(BonusManager.bonus_effects.h_1fury)
	pass
