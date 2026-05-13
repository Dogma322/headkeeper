extends Control

@onready var options_panel: OptionsPanel = $OptionsPanel
@onready var tooltip_panel: TooltipPanel = $TooltipPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	await get_tree().process_frame
	get_parent().move_child(self, get_parent().get_child_count())
