extends Node

## Деньги сохраняемые между забегами.
var money := 0:
	set(value):
		if money == value:
			return
		money = value

var buyed_head_keys := []
var selected_head_key := ""

func save_data():
	var file = FileAccess.open("user://meta.save", FileAccess.WRITE)
	var json = JSON.stringify({"money": money, "buyed_head_keys": buyed_head_keys, "selected_head_key": selected_head_key})
	file.store_string(json)
	file.close()
	pass

func load_data():
	if FileAccess.file_exists("user://meta.save"):
		var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("user://meta.save"))
		money = data.get("money", 0)
		selected_head_key = data.get("selected_head_key", "")
		buyed_head_keys = data.get("buyed_head_keys", [])
	pass

func _ready() -> void:
	load_data()
