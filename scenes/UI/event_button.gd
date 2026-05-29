@tool
extends GameButton
class_name EventButton

@onready var reward_label: RichTextLabel = %RewardLabel

@export var reward_text: String:
	set(value):
		if reward_text == value:
			return
		reward_text = value
		if is_instance_valid(reward_label):
			reward_label.text = value
			reward_label.visible = not value.is_empty()


func _ready() -> void:
	super()
	reward_label.text = reward_text
	reward_label.visible = not reward_text.is_empty()
