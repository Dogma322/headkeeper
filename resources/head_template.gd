extends Resource
class_name HeadTemplate

@export var hname: String
@export var skulls_cost: int
@export var gold_cost: int = 150
@export var textures: Array[Texture2D] = [null, null, null]

@export_enum("Weak", "Fury", "Corruption", "Thorns", "Vulnerable", "Evasion") var extra_tags: Array[String]

func get_translated_name() -> String:
	return tr(hname)

func get_translated_desc() -> String:
	return ""
