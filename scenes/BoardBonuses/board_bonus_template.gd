extends TextureRect
class_name BoardBonus

@export var distance: Distance

enum Distance {ANY, NEAR, MIDDLE, FAR}

@export var type: Type

enum Type {RED, GREEN, YELLOW}

var slot_owner

@onready var aim_marker = $Marker2D
@onready var tooltip_panel: TooltipPanel = $TooltipPanel

@onready var bb_name: String
@onready var description: String
@onready var value_label = $ValueLabel

func _ready() -> void:
	update_labels()
	tooltip_panel.hide()


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
	show_des()


func _on_mouse_exited():
	hide_des()


func show_des():
	if DominoManager.dm_dragging:
		return
	update_labels()
	z_index = 10
	tooltip_panel.show_tooltip()


func hide_des():
	if await tooltip_panel.hide_tooltip():
		z_index = 0


func update_labels():
	tooltip_panel.caption = ""
	tooltip_panel.description = ""
