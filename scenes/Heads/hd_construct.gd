extends Head

## Голова : Конструкт

func _ready() -> void:
	super()


func update_desc() -> void:
	if invert_logic:
		description = tr("HD_CONSTRUCT_DESC_ELITE") % [Constants.hd_construct_block_to_enemy]
	else:
		match level:
			0:
				description = tr("HD_CONSTRUCT_DESC") % [Constants.hd_construct_block_level_1]
			1:
				description = tr("HD_CONSTRUCT_DESC2") % [Constants.hd_construct_block_level_2, Constants.hd_construct_thorns_level_2]
			2:
				description = tr("HD_CONSTRUCT_DESC2") % [Constants.hd_construct_block_level_3, Constants.hd_construct_thorns_level_3]
	pass


func turn_begin_add_action() -> void:
	if invert_logic:
		ActionManager.add(BlockAction.new(self, Global.enemy, Constants.hd_construct_block_to_enemy))
		return
		
	var block := 0
	var thorns := 0
	match level:
		0:
			block = Constants.hd_construct_block_level_1
		1:
			block = Constants.hd_construct_block_level_2
			thorns = Constants.hd_construct_thorns_level_2
		2:
			block = Constants.hd_construct_block_level_3
			thorns = Constants.hd_construct_thorns_level_3
	if block > 0:
		ActionManager.add(BlockAction.new(self, Global.hero, block))
	if thorns > 0:
		ActionManager.add(BuffAction.new(self, Global.hero, StatusManager.thorns, thorns))
