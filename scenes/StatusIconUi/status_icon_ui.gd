extends TextureRect

@onready var status: StatusResource: set = set_status

@onready var stacks_label = $StacksLabel
@onready var des_panel = $DesPanel
@onready var name_label = $DesPanel/NameLabel
@onready var des_label = $DesPanel/DesLabel

@onready var st_name: String
@onready var description: String

var des_tween: Tween
var mouse_over_des = false

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
		
	if status.stacks <= 0 and !status.can_go_negative:
		status.remove_status_effect()
		queue_free()
		
	stacks_label.text = str(status.stacks)
	
	
	
	
	
func _on_mouse_entered():
	mouse_over_des = true
	show_des()
	#description_panel.visible = true


func _on_mouse_exited():
	mouse_over_des = false
	hide_des()
	#description_panel.visible = false
	
func show_des():

	if DominoManager.dm_dragging:
		return
	update_labels()
	
	z_index = 10

	des_panel.visible = true
	if des_tween and des_tween.is_running():
		des_tween.kill()
	
	
	if status.owner == Global.hero:
		des_panel.position = Vector2(20, -40)
	elif status.owner == Global.enemy:
		des_panel.position = Vector2(-107, -40)
	else:
		des_panel.position = Vector2.ZERO
	
	des_tween = get_tree().create_tween()
	des_tween.tween_property(des_panel, "modulate:a", 1, 0.15)
	


	
func hide_des():
	if not mouse_over_des: # не скрываем, если курсор снова вернулся
		if des_tween and des_tween.is_running():
			des_tween.kill()
		
		des_tween = get_tree().create_tween()
		des_tween.tween_property(des_panel, "modulate:a", 0, 0.15)
		await des_tween.finished
		if not mouse_over_des:
			des_panel.visible = false
		z_index = 0

func hide_des_fast():
	des_panel.visible = false
	
func update_labels():
	status.update_text()
	name_label.text = status.name
	des_label.text = status.des
