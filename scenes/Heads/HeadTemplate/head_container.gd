extends Control
class_name HeadContainer

var head: Head

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _on_mouse_entered() -> void:
	head._on_des_area_mouse_entered()


func _on_mouse_exited() -> void:
	head._on_des_area_mouse_exited()
