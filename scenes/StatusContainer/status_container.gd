extends HBoxContainer

@export var status_owner: Node

@onready var status_ui = preload("res://scenes/StatusIconUi/status_icon_ui.tscn")

func add_status(status, stacks):
	
	for status_icon in get_children():
		if status_icon.status.id == status.id:
			status_icon.status.stacks += stacks
			return
	
	var st_ui = status_ui.instantiate()
	add_child(st_ui)
	status.stacks = stacks
	status.owner = status_owner
	
	if not status.status_changed.is_connected(st_ui._on_status_changed):
		status.status_changed.connect(st_ui._on_status_changed)
	
	StatusManager.initialize_status(status)
	st_ui.status = status
	st_ui._on_status_changed()
	
	Signals.status_added.emit(status)
