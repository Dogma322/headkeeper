extends TextureRect

@onready var status: StatusResource: set = set_status

@onready var stacks_label = $StacksLabel
@onready var tooltip_panel: TooltipPanel = $TooltipPanel

@onready var st_name: String
@onready var description: String


func _ready() -> void:
	hide_des_fast()


func set_status(new_status: StatusResource):
	status = new_status
	texture = new_status.texture
	
	update_labels()
	
	if not status.status_changed.is_connected(_on_status_changed):
		status.status_changed.connect(_on_status_changed)
		
	_on_status_changed()


func _on_status_changed():

	if not status:
		return
		
	if !status.stackable:
		stacks_label.visible = false
		
	# 🔥 ВАЖНАЯ ЧАСТЬ
	if status.can_go_negative:
		if status.stacks == 0:
			StatusManager.remove_status_effect(status)
			queue_free()
	else:
		if status.stacks <= 0:
			StatusManager.remove_status_effect(status)
			queue_free()
		
	stacks_label.text = str(status.stacks)


func _on_mouse_entered():
	show_des()


func _on_mouse_exited():
	hide_des()


func show_des():

	if DominoManager.dm_dragging:
		return
	update_labels()
	
	z_index = 10
	tooltip_panel.show_tooltip()
	
	
	if status.owner == Global.hero:
		tooltip_panel.position = Vector2(20, -40)
	elif status.owner == Global.enemy:
		tooltip_panel.position = Vector2(-107, -40)
	else:
		tooltip_panel.position = Vector2.ZERO
	
	tooltip_panel.reset_size()
	tooltip_panel.show_tooltip(true)


func hide_des():
	if await tooltip_panel.hide_tooltip():
		z_index = 0


func hide_des_fast():
	tooltip_panel.visible = false


func update_labels():
	status.update_text()
	tooltip_panel.caption = status.name
	tooltip_panel.description = status.des
