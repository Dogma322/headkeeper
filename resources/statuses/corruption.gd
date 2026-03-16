extends StatusResource

func apply_status_effect():
	ActionManager.add(CorruptionAttackAction.new(Global.enemy, stacks))

func update_text():
	name = tr("st_corruption_name")
	des = tr("st_corruption_in_game_des") % stacks
