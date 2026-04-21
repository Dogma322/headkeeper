extends Node

## Черепа сохраняемые между забегами.
var skulls := 0:
	set(value):
		if skulls == value:
			return
		skulls = value

## Золото сохраняемое между забегами.
var gold := 0:
	set(value):
		if gold == value:
			return
		gold = value

var buyed_head_keys := []
var selected_head_key := ""

func save_data():
	var file = FileAccess.open("user://meta.save", FileAccess.WRITE)
	var json = JSON.stringify({"skulls": skulls, "gold": gold, "buyed_head_keys": buyed_head_keys, "selected_head_key": selected_head_key})
	file.store_string(json)
	file.close()
	pass

func load_data():
	if FileAccess.file_exists("user://meta.save"):
		var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("user://meta.save"))
		skulls = data.get("skulls", 0)
		gold = data.get("gold", 0)
		selected_head_key = data.get("selected_head_key", "")
		buyed_head_keys = data.get("buyed_head_keys", [])
	pass

func _ready() -> void:
	load_data()
