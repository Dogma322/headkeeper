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


func update_desc() -> void:
	if invert_logic:
		description = tr("hd_eternal_fury_des_elite")
	else:
		match level:
			1:
				description = tr("hd_eternal_fury_des2")
			2:
				description = tr("hd_eternal_fury_des3")
			_:
				description = tr("hd_eternal_fury_des")


func apply_passive_effect() -> void:
	if invert_logic:
		Global.enemy.bonus_pool.append(BoardManager.e_3fury)
	else:
		BoardManager.bonus_pool.append(BoardManager.h_1fury)
		BoardManager.bonus_pool.append(BoardManager.h_1fury)



func remove_passive_effect() -> void:
	if invert_logic:
		Global.enemy.bonus_pool.erase(BoardManager.e_3fury)
	else:
		BoardManager.bonus_pool.erase(BoardManager.h_1fury)
		BoardManager.bonus_pool.erase(BoardManager.h_1fury)
