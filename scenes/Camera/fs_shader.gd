extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.custom_minimum_size = DisplayServer.screen_get_size()
