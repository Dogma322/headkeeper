extends Node

@onready var skulls_rewards = preload("res://resources/rewards/skulls_rewards.tres")

var skulls := 0:
	set(value):
		if skulls == value:
			return
		skulls = value
		Signals.skulls_changed.emit(skulls)

var gold := 0:
	set(value):
		if gold == value:
			return
		gold = value
		Signals.gold_changed.emit(gold)


func _ready() -> void:
	Signals.reset_run_data.connect(reset_run)


func reset_run():
	MetaManager.skulls += skulls
	MetaManager.save_data()
	skulls = 0
	gold = 0
