extends EventAction
class_name EventActionAddHealthPoints

## Действие события - добавление/отнятие очков жизни.

@export var amount := 0

func play() -> void:
	Global.hero.health += amount
