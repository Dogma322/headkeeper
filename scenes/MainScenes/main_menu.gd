extends Node2D

@export var money_label: RichTextLabel

func set_money(money: int) -> void:
	money_label.text = str(money)

func _ready() -> void:
	Transition.blackout_off()
	Signals.meta_money_changed.connect(set_money)
	set_money(MetaManager.money)


func _on_reset_progress_button_pressed() -> void:
	MetaManager.money = 0
