extends EventAction
class_name EventActionAddGold

## Действие события - добавление золота.

@export var amount := 0

func play() -> void:
	Run.gold += amount
