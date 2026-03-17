extends Head


func _ready() -> void:
	armor = 5
	hd_name = tr("hd_brick_name")
	description = tr("hd_brick_des") % armor
	super()
	
	
func turn_begin_add_action():
	ActionManager.add(BlockAction.new(self, Global.hero, 5))
