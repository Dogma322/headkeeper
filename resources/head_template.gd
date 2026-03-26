extends Resource
class_name HeadTemplate

@export var hname: String
@export var desc: String
@export var cost: int
@export var damage = 0
@export var armor = 0
@export var heal = 0
@export var corruption = 0
@export var value = 0
@export var min_value = 0
@export var max_value = 0
@export var texture: Texture2D
@export var extra_tags: PackedStringArray

func get_translated_name() -> String:
	return tr(hname)

func get_translated_desc() -> String:
	var values = []
	if damage != 0:
		values.push_back(damage)
	if armor != 0:
		values.push_back(armor)
	if heal != 0:
		values.push_back(heal)
	if corruption != 0:
		values.push_back(corruption)
	if value != 0:
		values.push_back(value)
	if min_value != 0 and max_value != 0:
		values.push_back(min_value)
		values.push_back(max_value)
	elif min_value != 0:
		values.push_back(min_value)
	if values.is_empty():
		return tr(desc)
	return tr(desc) % values
