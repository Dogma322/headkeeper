extends Node2D

var random_boards = true

var green_bonuses_activated = 0


@onready var h_5dmg_bonus = preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_5_damage.tscn")
@onready var h_4def_bonus = preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_4_defense.tscn")
@onready var h_3heal = preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_heal.tscn")
@onready var h_draw = preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_draw.tscn")
@onready var h_thorns = preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_thorns.tscn")
@onready var h_1fury = preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_1_fury.tscn")
@onready var h_1vulnerable = preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_1_vulnerable.tscn")
@onready var h_1weak = preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_1_weak.tscn")
@onready var h_1crit = preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_1_crit.tscn")
@onready var h_1repeat = preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_1_repeat.tscn")

@onready var e_5dmg = preload("res://scenes/BoardBonuses/EnemyBonuses/bb_e_5_damage.tscn")
@onready var e_10dmg = preload("res://scenes/BoardBonuses/EnemyBonuses/bb_e_10_damage.tscn")
@onready var e_15dmg = preload("res://scenes/BoardBonuses/EnemyBonuses/bb_e_15_damage.tscn")
@onready var e_4def = preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_4_defense.tscn")
@onready var e_10def = preload("res://scenes/BoardBonuses/EnemyBonuses/bb_e_10_defense.tscn")
@onready var e_15def = preload("res://scenes/BoardBonuses/EnemyBonuses/bb_e_15_defense.tscn")
@onready var e_5fury = preload("res://scenes/BoardBonuses/EnemyBonuses/bb_e_5_fury.tscn")
@onready var e_10fury = preload("res://scenes/BoardBonuses/EnemyBonuses/bb_e_10_fury.tscn")
@onready var e_5heal = preload("res://scenes/BoardBonuses/EnemyBonuses/bb_e_5_heal.tscn")
@onready var e_10heal = preload("res://scenes/BoardBonuses/EnemyBonuses/bb_h_10_heal.tscn")
@onready var e_15heal = preload("res://scenes/BoardBonuses/EnemyBonuses/bb_e_15_heal.tscn")
@onready var e_2vulnerable = preload("res://scenes/BoardBonuses/EnemyBonuses/bb_e_2_vulnerable.tscn")
@onready var e_2weak = preload("res://scenes/BoardBonuses/EnemyBonuses/bb_e_2_weak.tscn")
@onready var e_1thorns = preload("res://scenes/BoardBonuses/EnemyBonuses/bb_e_1_thorns.tscn")
@onready var e_2thorns = preload("res://scenes/BoardBonuses/EnemyBonuses/bb_e_2_thorns.tscn")
@onready var e_decrease_5_max_hp = preload("res://scenes/BoardBonuses/EnemyBonuses/bb_e_decrease_5_max_hp.tscn")
@onready var e_1evasion = preload("res://scenes/BoardBonuses/EnemyBonuses/bb_e_1_evasion.tscn")
@onready var e_void = preload("res://scenes/BoardBonuses/EnemyBonuses/bb_e_void.tscn")

@onready var n_remove_invincible = preload("res://scenes/BoardBonuses/NeutralBonuses/bb_e_remove_invincible.tscn")
@onready var n_larva = preload("res://scenes/BoardBonuses/NeutralBonuses/bb_n_larva.tscn")
@onready var n_remove_armor = preload("res://scenes/BoardBonuses/NeutralBonuses/bb_n_remove_armor.tscn")
@onready var n_remove_5fury = preload("res://scenes/BoardBonuses/NeutralBonuses/bb_n_remove_5_fury.tscn")
@onready var n_remove_10fury = preload("res://scenes/BoardBonuses/NeutralBonuses/bb_n_remove_10_fury.tscn")

@onready var bonus_pool = [h_5dmg_bonus, h_4def_bonus]

@onready var board1 = preload("res://scenes/Boards/BoardTemplate/board_1.tscn")

@onready var board2 = preload("res://scenes/Boards/board_2.tscn")
@onready var board3 = preload("res://scenes/Boards/board_3.tscn")
@onready var board4 = preload("res://scenes/Boards/board_4.tscn")

@onready var board5 = preload("res://scenes/Boards/board_5.tscn")
@onready var board6 = preload("res://scenes/Boards/board_6.tscn")
@onready var board7 = preload("res://scenes/Boards/board_7.tscn")
@onready var board8 = preload("res://scenes/Boards/board_8.tscn")
@onready var board9 = preload("res://scenes/Boards/board_9.tscn")

@onready var board_pool 

var slots = []
var target_slot

func _ready():
	if random_boards == true:
		board_pool = [board1, board5, board6, board7, board8, board9]
	else:
		board_pool = [board1]
	
	
	slots = get_tree().get_nodes_in_group("domino_slots")
	Signals.reset_run_data.connect(reset_run)

func reset_run():
	bonus_pool = [h_5dmg_bonus, h_4def_bonus]
	if random_boards == true:
		board_pool = [board1, board5, board6, board7, board8, board9]
	else:
		board_pool = [board1]
	
func generate_board():
	var pos = Global.board.global_position

	if board_pool.size() == 0:
		if random_boards:
			board_pool = [board1, board5, board6, board7, board8, board9]
		else:
			board_pool = [board1]

	var board_scene = board_pool.pick_random() # ← берём сцену
	board_pool.erase(board_scene)              # ← удаляем сцену

	var new_board = board_scene.instantiate() # ← создаём объект

	Global.board.queue_free()
	Global.board = new_board
	Global.fight_scene.add_child(new_board)
	new_board.global_position = pos


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


	var bonuses = bonus_pool + Global.enemy.bonus_pool



	for bonus_scene in bonuses:

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
