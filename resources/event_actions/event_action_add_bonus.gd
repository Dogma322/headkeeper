extends EventAction
class_name EventActionAddBonus

## Действие события - добавление бонуса.

@export var id: String

func play() -> void:
	var bonus = null
	if BonusManager.bonus_templates.has(id):
		bonus = BonusManager.bonus_templates[id]
	elif BonusManager.special_bonus_templates.has(id):
		bonus = BonusManager.special_bonus_templates[id]
	if bonus != null:
		Run.current_bonus_pool.erase(bonus.tag)
		var bonus_fx = BonusManager.bonus_effects[bonus.tag]
		if not BoardManager.bonus_pool.has(bonus_fx):
			BoardManager.bonus_pool.append(bonus_fx)
	else:
		printerr("EventActionAddBonus error: \"%s\" does not exist" % [id])
