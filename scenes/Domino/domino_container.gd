extends Control

var domino: Domino

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	domino._on_area_2d_mouse_entered()

func _on_mouse_exited():
	domino._on_area_2d_mouse_exited()
