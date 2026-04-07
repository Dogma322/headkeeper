@tool
extends Node2D
class_name DominoSide

@onready var one: Node2D = %One
@onready var two: Node2D = %Two
@onready var three: Node2D = %Three
@onready var four: Node2D = %Four
@onready var slot_sets = [one, two, three, four]
@onready var side_sprite: Sprite2D = $SideSprite

var current_slot_set: Node2D = null

static var color_storage = {
	"red": "red",
	"blue": "blue",
	"green": "green"
}

static var color_to_block_top_tex = {
	"red": preload("res://assets/Dominoes/Blocks/top_red_block.atlastex"),
	"blue": preload("res://assets/Dominoes/Blocks/top_blue_block.atlastex"),
	"green": preload("res://assets/Dominoes/Blocks/top_green_block.atlastex"),
}

static var color_to_block_bot_tex = {
	"red": preload("res://assets/Dominoes/Blocks/bot_red_block.atlastex"),
	"blue": preload("res://assets/Dominoes/Blocks/bot_blue_block.atlastex"),
	"green": preload("res://assets/Dominoes/Blocks/bot_green_block.atlastex"),
}

static var type_to_tex = {
	"attack": {
		"red": preload("res://assets/Dominoes/Symbols/attack_red.atlastex"),
		"blue": preload("res://assets/Dominoes/Symbols/attack_blue.atlastex"),
		"green": preload("res://assets/Dominoes/Symbols/attack_green.atlastex"),
	},
	"attack2": {
		"red": preload("res://assets/Dominoes/Symbols/attack2_red.atlastex"),
		"blue": preload("res://assets/Dominoes/Symbols/attack2_blue.atlastex"),
		"green": preload("res://assets/Dominoes/Symbols/attack2_green.atlastex"),
	},
	"claws": {
		"red": preload("res://assets/Dominoes/Symbols/claws_red.atlastex"),
		"blue": preload("res://assets/Dominoes/Symbols/claws_blue.atlastex"),
		"green": preload("res://assets/Dominoes/Symbols/claws_green.atlastex"),
	},
	"defense": {
		"red": preload("res://assets/Dominoes/Symbols/defense_red.atlastex"),
		"blue": preload("res://assets/Dominoes/Symbols/defense_blue.atlastex"),
		"green": preload("res://assets/Dominoes/Symbols/defense_green.atlastex"),
	},
	"heal": {
		"red": preload("res://assets/Dominoes/Symbols/heal_red.atlastex"),
		"blue": preload("res://assets/Dominoes/Symbols/heal_blue.atlastex"),
		"green": preload("res://assets/Dominoes/Symbols/heal_green.atlastex"),
	},
	"spear": {
		"red": preload("res://assets/Dominoes/Symbols/spear_red.atlastex"),
		"blue": preload("res://assets/Dominoes/Symbols/spear_blue.atlastex"),
		"green": preload("res://assets/Dominoes/Symbols/spear_green.atlastex"),
	},
}

static var special_to_tex = {
	"vulnerable": preload("res://assets/Dominoes/Symbols/vulnerable.atlastex")
}

## false is top, true is bottom
@export var side: bool:
	set(value):
		if side == value:
			return
		side = value
		update_side_graphics()
		update_slot_graphics()

@export_enum("red", "blue", "green") var color: String = "red":
	set(value):
		if color == value:
			return
		color = value
		update_side_graphics()
		update_slot_graphics()

@export_range(1, 4) var count: int = 1:
	set(value):
		if count == value:
			return
		count = value
		update_slot_count()
		update_slot_graphics()

@export_enum("attack", "attack2", "claws", "defense", "heal", "spear") var type: String = "defense":
	set(value):
		if type == value:
			return
		type = value
		update_slot_graphics()

@export var slots_rotation: int = false:
	set(value):
		if slots_rotation == value:
			return
		slots_rotation = value
		update_slot_sets()

func update_side_graphics() -> void:
	if not is_instance_valid(side_sprite):
		return
	if side:
		side_sprite.texture = color_to_block_bot_tex.get(color, null)
	else:
		side_sprite.texture = color_to_block_top_tex.get(color, null)
	update_slot_sets()

func update_slot_sets():
	for slot_set in slot_sets:
		if is_instance_valid(slot_set):
			slot_set.rotation_degrees = slots_rotation
			#print(slot_set.rotation_degrees)
			
			#slot_set.position.x = 0
			#slot_set.position.y = 0
			#
			#match slot_set.rotation_degrees:
				#0.0:
					#if side:
						#slot_set.position.y = -2
				#-90.0:
					#slot_set.position.x = -1
					#slot_set.position.y = 0
				#-180.0:
					#if not side:
						#slot_set.position.y = 2

func update_slot_count() -> void:
	if slot_sets == null:
		return
	var i = 0
	for slot_set in slot_sets:
		if is_instance_valid(slot_set):
			if i + 1 == count:
				current_slot_set = slot_set
				slot_set.show()
			else:
				slot_set.hide()
		i += 1

func update_slot_graphics():
	if current_slot_set != null:
		for child in current_slot_set.get_children():
			if child is Sprite2D:
				if special_to_tex.has(type):
					child.texture = special_to_tex[type]
				else:
					var data: Dictionary = type_to_tex.get(type, {})
					if not data.is_empty():
						child.texture = data.get(color, null)
				pass

func _ready() -> void:
	update_side_graphics()
	update_slot_count()
	update_slot_graphics()
