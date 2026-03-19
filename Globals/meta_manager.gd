extends Node

## Деньги сохраняемые между забегами.
var money := 0:
	set(value):
		if money == value:
			return
		money = value
		if emit_meta_money_signal:
			Signals.meta_money_changed.emit(value)
			save_data()

var emit_meta_money_signal := false

func save_data():
	var file = FileAccess.open("user://meta.save", FileAccess.WRITE)
	var json = JSON.stringify({"money": money})
	file.store_string(json)
	file.close()
	pass

func load_data():
	if FileAccess.file_exists("user://meta.save"):
		var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("user://meta.save"))
		money = data.money
	pass

func _ready() -> void:
	load_data()
	emit_meta_money_signal = true
