extends TextureRect

@onready var status: StatusResource: set = set_status

@onready var stacks_label = $StacksLabel

func set_status(new_status: StatusResource):
	status = new_status
	texture = new_status.texture
	new_status.status_changed.connect(_on_status_changed)
	_on_status_changed()
	
func _on_status_changed():
	if not status:
		return
		
	if status.reducible and status.stacks <= 0:
		queue_free()
		
	stacks_label.text = str(status.stacks)
