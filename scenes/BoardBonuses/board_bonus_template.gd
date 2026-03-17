extends TextureRect
class_name BoardBonus

@export var distance: Distance

enum Distance {ANY, NEAR, MIDDLE, FAR}

@export var type: Type

enum Type {RED, GREEN, YELLOW}

var slot_owner

var mouse_over_des = false
var des_tween: Tween

@onready var aim_marker = $Marker2D
@onready var des_panel = $DesPanel
@onready var name_label = $DesPanel/NameLabel
@onready var des_label = $DesPanel/DesLabel

@onready var bb_name: String
@onready var description: String
@onready var value_label = $ValueLabel

func _ready() -> void:
	update_labels()
	hide_des()

func play_anim():
	
	if type == 1:
		BoardManager.green_bonuses_activated += 1
		
	z_index = 999
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(self, "scale", Vector2(4,4), 0.5)
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	queue_free()
	
func add_actions():
	add_action()
	bonus_played()
	
func add_action():
	ActionManager.add(AttackAction.new(self, Global.enemy, 5))
	
func bonus_played():
	if type == 0:
		Signals.red_bonus_played.emit()
	if type == 1:
		Signals.green_bonus_played.emit()
	if type == 2:
		Signals.yellow_bonus_played.emit()

	

		
	
func _on_mouse_entered():
	mouse_over_des = true
	show_des()

func _on_mouse_exited():
	mouse_over_des = false
	hide_des()

	
func show_des():
	if DominoManager.dm_dragging:
		return
	update_labels()
	z_index = 10

	des_panel.visible = true
	if des_tween and des_tween.is_running():
		des_tween.kill()
	
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

func update_labels():
	name_label.text = ""
	des_label.text = ""
