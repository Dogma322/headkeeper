extends Node

## Содержит данные текущего забега.

var reserved_head_pool := {}
var current_head_pool: Array[Head] = []

var current_bonus_pool := {}

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


func reset_data() -> void:
	reserved_head_pool = HeadManager.head_templates.duplicate()
	current_head_pool.clear()
	
	current_bonus_pool = BonusManager.bonus_templates.duplicate()
	current_bonus_pool.erase("attack5")
	current_bonus_pool.erase("defense5")


func _ready() -> void:
	reset_data()
	Signals.reset_run_data.connect(reset)


func reset():
	reset_data()
	
	MetaManager.skulls += skulls
	MetaManager.save_data()
	skulls = 0
	gold = 0
	
	for head in Global.enemy_head_holder.get_children():
		if head is Head:
			head.remove_passive_effect()
			head.queue_free()
	
	for head in Global.head_holder.get_children():
		if head is Head:
			head.remove_passive_effect()
			head.queue_free()
