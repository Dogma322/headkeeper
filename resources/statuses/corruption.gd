extends StatusResource

func apply_status_effect():
	ActionManager.add(CorruptionAttackAction.new(Global.enemy, stacks))
