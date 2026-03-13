extends StatusResource

func apply_status_effect():
	print("CORRUPT")
	ActionManager.add(CorruptionAttackAction.new(Global.enemy, stacks))
