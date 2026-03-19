extends Node

@onready var money_rewards = preload("res://resources/rewards/money_rewards.tres")

var money := 0:
	set(value):
		if money == value:
			return
		money = value
		Signals.money_changed.emit(money)

func _ready() -> void:
	Signals.reset_run_data.connect(reset_run)

func reset_run():
	MetaManager.money += money
	money = 0
