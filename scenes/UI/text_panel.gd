@tool
class_name TextPanel
extends MarginContainer

@onready var text_label: RichTextLabel = %TextLabel

@export var text: String:
	set(value):
		text = value
		if is_instance_valid(text_label):
			text_label.text = "[center]%s[/center]" % text

func _ready() -> void:
	text_label.text = "[center]%s[/center]" % text
