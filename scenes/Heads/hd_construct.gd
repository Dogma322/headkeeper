extends Head

func _ready() -> void:
	super()


func turn_begin_add_action():
	ActionManager.add(BlockAction.new(self, Global.hero, 5))
