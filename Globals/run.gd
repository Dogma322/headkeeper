extends Node

## Содержит данные текущего забега.

var current_head_pool := {}
var current_bonus_pool := {}

var gold := 0


func reset_data() -> void:
	current_head_pool = HeadManager.head_templates.duplicate()
	
	current_bonus_pool = BonusManager.bonus_templates.duplicate()
	# current_bonus_pool.erase("attack5")
	# current_bonus_pool.erase("defense5")


func _ready() -> void:
	reset_data()
	Signals.reset_run_data.connect(reset)


func reset():
	reset_data()
	
	for head in Global.head_holder.get_children():
		head.remove_passive_effect()
		head.queue_free()
