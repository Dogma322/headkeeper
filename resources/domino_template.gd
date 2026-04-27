extends Resource
class_name DominoTemplate

@export var a_types: PackedStringArray
@export var b_types: PackedStringArray

@export_enum("red", "blue", "green") var a_color: String = "red"
@export_enum("red", "blue", "green") var b_color: String = "red"

@export var gold_cost := 50
