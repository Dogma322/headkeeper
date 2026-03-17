extends HBoxContainer

func _ready() -> void:
	Global.board_bonus_container = self
	for bb in get_children():
		bb.queue_free()

func add_bonus_actions():
	for bb in get_children():
		bb.add_actions()
