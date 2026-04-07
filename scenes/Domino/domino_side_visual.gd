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
	"empty": {
		"red": preload("res://assets/Dominoes/Symbols/slot_red.atlastex"),
		"blue": preload("res://assets/Dominoes/Symbols/slot_blue.atlastex"),
		"green": preload("res://assets/Dominoes/Symbols/slot_green.atlastex"),
	},
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
	"dagger": {
		"red": preload("res://assets/Dominoes/Symbols/dagger_red.atlastex"),
		"blue": preload("res://assets/Dominoes/Symbols/dagger_blue.atlastex"),
		"green": preload("res://assets/Dominoes/Symbols/dagger_green.atlastex"),
	},
	"defense": {
		"red": preload("res://assets/Dominoes/Symbols/defense_red.atlastex"),
		"blue": preload("res://assets/Dominoes/Symbols/defense_blue.atlastex"),
		"green": preload("res://assets/Dominoes/Symbols/defense_green.atlastex"),
	},
	"hammer": {
		"red": preload("res://assets/Dominoes/Symbols/hammer_red.atlastex"),
		"blue": preload("res://assets/Dominoes/Symbols/hammer_blue.atlastex"),
		"green": preload("res://assets/Dominoes/Symbols/hammer_green.atlastex"),
	},
	"heal": {
		"red": preload("res://assets/Dominoes/Symbols/heal_red.atlastex"),
		"blue": preload("res://assets/Dominoes/Symbols/heal_blue.atlastex"),
		"green": preload("res://assets/Dominoes/Symbols/heal_green.atlastex"),
	},
	"mace": {
		"red": preload("res://assets/Dominoes/Symbols/mace_red.atlastex"),
		"blue": preload("res://assets/Dominoes/Symbols/mace_blue.atlastex"),
		"green": preload("res://assets/Dominoes/Symbols/mace_green.atlastex"),
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
		update_side()

@export_enum("red", "blue", "green") var color: String = "red":
	set(value):
		if color == value:
			return
		color = value
		update_side()

@export_range(1, 4) var count: int = 1:
	set(value):
		if count == value:
			return
		count = value
		update_slot_sets()
		init_slots()
		update_slots()

@export var slots_rotation: int = false:
	set(value):
		if slots_rotation == value:
			return
		slots_rotation = value
		update_rotation()

class Slot:
	var type: String
	var sprite: Sprite2D
	
	func _init(_type: String, _sprite: Sprite2D):
		self.type = _type
		self.sprite = _sprite

var slots: Array[Slot] = []
var initialized = false
var pending_update := false

func init_slots():
	if not initialized:
		return
	
	slots.clear()
	slots.resize(count)
	for j in range(count):
		slots[j] = Slot.new("empty", current_slot_set.get_child(j) as Sprite2D)

func get_free_slot() -> Slot:
	for slot in slots:
		if slot.type == "empty":
			return slot
	return null

func push_symbol(symbol: String) -> void:
	var slot = get_free_slot()
	if slot != null:
		slot.type = symbol
	if not pending_update:
		pending_update = true
		update_slots.call_deferred()

func update_side() -> void:
	if not initialized:
		return
	
	if side:
		side_sprite.texture = color_to_block_bot_tex.get(color, null)
	else:
		side_sprite.texture = color_to_block_top_tex.get(color, null)

func update_rotation():
	for slot_set in slot_sets:
		slot_set.rotation_degrees = slots_rotation

func update_slot_sets():
	var i := 0
	for slot_set in slot_sets:
		if i + 1 == count:
			current_slot_set = slot_set
			slot_set.show()
		else:
			slot_set.hide()
		i += 1

func update_slots() -> void:
	if not initialized:
		return
	pending_update = false
	for slot in slots:
		var type = slot.type
		if special_to_tex.has(type):
			slot.sprite.texture = special_to_tex[type]
		else:
			var data: Dictionary = type_to_tex.get(type, {})
			if not data.is_empty():
				slot.sprite.texture = data.get(color, null)

func _ready() -> void:
	initialized = true
	update_side()
	update_rotation()
	update_slot_sets()
	init_slots()
	update_slots()
