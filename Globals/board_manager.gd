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

	var all_slots = get_tree().get_nodes_in_group("DominoSlots")

	# очищаем старые бонусы
	for slot in all_slots:
		slot.remove_bonuses()

	for bonus_scene in bonus_pool:

		var bonus = bonus_scene.instantiate()
		var valid_slots = []

		for slot in all_slots:

			if slot.start_slot:
				continue

			if slot.bonuses.size() >= 2:
				continue

			if !is_distance_valid(bonus.distance, slot.slot_distance):
				continue

			valid_slots.append(slot)

		if valid_slots.size() == 0:
			print("No slot for bonus")
			continue

		var slot = valid_slots.pick_random()
		slot.add_bonus(bonus)

func is_distance_valid(bonus_distance, slot_distance):

	match bonus_distance:

		BoardBonus.Distance.ANY:
			return true

		BoardBonus.Distance.NEAR:
			return slot_distance == DominoSlot.SlotDistance.NEAR

		BoardBonus.Distance.MIDDLE:
			return slot_distance == DominoSlot.SlotDistance.NEAR \
			or slot_distance == DominoSlot.SlotDistance.MIDDLE

		BoardBonus.Distance.FAR:
			return slot_distance == DominoSlot.SlotDistance.NEAR \
			or slot_distance == DominoSlot.SlotDistance.MIDDLE \
			or slot_distance == DominoSlot.SlotDistance.FAR

	return false
