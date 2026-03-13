extends Node2D

@onready var bonus = preload("res://scenes/BoardBonuses/board_bonus_template.tscn")
@onready var bonus_pool = [bonus, bonus, bonus, bonus, bonus]

var slots = []
var target_slot



func _ready():
	slots = get_tree().get_nodes_in_group("domino_slots")



func get_closest_slot(pos:Vector2):

	var best_slot = null
	var best_dist = 99999

	for slot in slots:

		var d = pos.distance_to(slot.global_position)

		if d < 100 and d < best_dist:

			best_dist = d
			best_slot = slot

	return best_slot

func highlight_avaiable_slots(numbers: Array):
	for value in numbers:
		for slot in get_tree().get_nodes_in_group("DominoSlots"):
			if slot.start_slot:
				slot.highlight()
				continue
			if slot.get_required_value() == value:
				slot.highlight()
				
func disable_highlight():
	for slot in get_tree().get_nodes_in_group("DominoSlots"):
		slot.disable_highlight()
		
		
func generate_bonuses():
	var temp_slots = []
	for slot in get_tree().get_nodes_in_group("DominoSlots"):
		slot.remove_bonuses()
		temp_slots.append(slot)
		
		
	for bb in bonus_pool:
		var slot = temp_slots.pick_random()
		slot.add_bonus(bb.instantiate())
