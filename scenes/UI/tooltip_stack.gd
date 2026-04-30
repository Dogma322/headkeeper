extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var size_x = 0
	
	for child: TooltipPanel in get_children():
		size_x += child.size.x
	
	#if global_position.x < 0:
	#	global_position.x = 0
	#elif global_position.x + size_x > get_viewport_rect().size.x:
	#	global_position.x = get_viewport_rect().size.x - size_x
