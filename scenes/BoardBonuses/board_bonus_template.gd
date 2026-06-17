@tool
extends TextureRect
class_name BoardBonus

@export var distance: Distance

enum Distance {ANY, NEAR, MIDDLE, FAR}

@export var type: Type:
	set(value):
		type = value
		if icon_rect and icon_rect.texture != null:
			match type:
				Type.DEBUFF:
					texture = preload("res://assets/Dominoes/Blocks/red_block.atlastex")
					pass
				Type.BUFF:
					texture = preload("res://assets/Dominoes/Blocks/green_block.atlastex")
					pass

enum Type {DEBUFF, BUFF, NEUTRAL}

var slot_owner

@onready var value_label: Label = %ValueLabel
@onready var icon_rect: TextureRect = %IconRect

@onready var aim_marker = $Marker2D
@onready var tooltip_panel: TooltipPanel = $TooltipPanel

@onready var bb_name: String
@onready var description: String

func _ready() -> void:
	if icon_rect.texture != null:
		match type:
			Type.DEBUFF:
				texture = load("res://assets/Dominoes/Blocks/red_block.atlastex")
			Type.BUFF:
				texture = load("res://assets/Dominoes/Blocks/green_block.atlastex")
			Type.NEUTRAL:
				texture = load("res://assets/Dominoes/Blocks/grey_block.atlastex")
	
	if Engine.is_editor_hint():
		return
	
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


func add_actions():
	if type == Type.BUFF:
		for i in range(1 + Global.hero.repeat_positive_bonus_counter):
			add_action()
	else:
		add_action()
	bonus_played()


func add_action():
	pass


func bonus_played():
	if type == Type.DEBUFF:
		Signals.red_bonus_played.emit()
	if type == Type.BUFF:
		Signals.green_bonus_played.emit()
		Global.hero.repeat_positive_bonus_counter = 0
	if type == Type.NEUTRAL:
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
	tooltip_panel.show_tooltip(true)


func hide_des():
	if await tooltip_panel.hide_tooltip():
		z_index = 0


func update_labels():
	tooltip_panel.caption = ""
	tooltip_panel.description = ""
