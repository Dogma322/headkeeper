class_name DominoSlot
extends Node2D


enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

@export var start_slot: bool = false
@export var parent_slot: DominoSlot
@export var direction: Direction
@export var orientation:Orientation
@export var slot_distance: SlotDistance

enum SlotDistance { START, NEAR, MIDDLE, FAR }


var domino:Domino = null
var child_slots:Array[DominoSlot] = []
var mouse_inside := false

var bonuses = []

@onready var container = $Container



func _ready():

	if parent_slot:
		parent_slot.child_slots.append(self)

	disable_highlight()



func get_required_value():

	if start_slot:
		return null

	if parent_slot.domino == null:
		return null

	var d = parent_slot.domino

	var open_value = d.get_open_value()

	var connected_value

	if d.connected_side == 0:
		connected_value = d.a
	else:
		connected_value = d.b


	# определяем слот через который домино подключено
	var entry_dir = parent_slot.direction

	# слот продолжает цепь
	if direction == entry_dir:
		return open_value

	# слот с противоположной стороны
	if direction == opposite_direction(entry_dir):
		return connected_value

	# боковые ветки
	return open_value



func opposite_direction(dir):

	match dir:
		Direction.UP:
			return Direction.DOWN
		Direction.DOWN:
			return Direction.UP
		Direction.LEFT:
			return Direction.RIGHT
		Direction.RIGHT:
			return Direction.LEFT

	return dir



func can_place(new_domino:Domino):

	if domino != null:
		return false

	if start_slot:
		return true

	if !parent_slot.domino:
		return false

	var needed = get_required_value()

	if new_domino.a == needed:
		return true

	if new_domino.b == needed:
		return true

	return false



func place_domino(new_domino:Domino):

	var needed = get_required_value()

	if needed != null:

		if new_domino.a == needed:
			new_domino.connected_side = 0
		else:
			new_domino.connected_side = 1

		new_domino.rotate_to_match(needed, direction)

	domino = new_domino
	new_domino.slot = self

	new_domino.global_position = global_position

	DominoManager.dominoes_on_board.append(new_domino)

	add_bonuses_to_bb_cont()



func add_bonuses_to_bb_cont():

	for bb in bonuses:
		bb.get_parent().remove_child(bb)
		Global.board_bonus_container.add_child(bb)



func remove_chain():

	if domino == null:
		return

	for child in child_slots:
		child.remove_chain()

	var d = domino

	remove_domino()

	Hand.add_domino(d)



func remove_domino():

	if domino == null:
		return

	DominoManager.dominoes_on_board.erase(domino)

	domino.slot = null
	domino = null

	for bb in bonuses:
		if bb != null:
			bb.get_parent().remove_child(bb)
			container.add_child(bb)



func _on_area_2d_mouse_entered():
	mouse_inside = true
	BoardManager.target_slot = self


func _on_area_2d_mouse_exited():
	mouse_inside = false



func highlight():
	$HighlightAnim.visible = true


func disable_highlight():
	$HighlightAnim.visible = false



func add_bonus(bonus):
	bonuses.append(bonus)
	container.add_child(bonus)
	bonus.owner = self


func remove_bonuses():
	bonuses.clear()
	for bb in container.get_children():
		bb.queue_free()
