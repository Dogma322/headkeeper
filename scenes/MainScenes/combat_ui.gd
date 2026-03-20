extends Node2D
class_name CombatUI

## Текстовая метка для денег.
@export var money_label: RichTextLabel

## Устанавливает деньги в текстовую метку денег.
func set_money(amount: int) -> void:
	money_label.text = str(amount)

func _ready() -> void:
	Signals.money_changed.connect(set_money)
	pass
