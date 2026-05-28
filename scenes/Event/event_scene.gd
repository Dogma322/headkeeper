extends ScreenBase
class_name EventScene

@onready var title_label: Label = %TitleLabel
@onready var description_rich_text_label: RichTextLabel = %DescriptionRichTextLabel
@onready var buttons_vbox_container: VBoxContainer = %ButtonsVBoxContainer

const EVENT_BUTTON = preload("uid://bemk37cis2wkk")


func start_event(event: EventTemplate) -> void:
	assert(event)
	assert(event.event_scene)
	
	start_event_scene(event.event_scene)


func start_event_scene(event_scene: EventSceneTemplate) -> void:
	title_label.text = tr(event_scene.title)
	description_rich_text_label.text = tr(event_scene.description)
	
	if event_scene.next.is_empty():
		var button: EventButton = EVENT_BUTTON.instantiate()
		button.text = tr("EVENT_EXIT_BTN")
		buttons_vbox_container.add_child(button)
	else:
		for data in event_scene.next:
			if data == null:
				continue
			var button: EventButton = EVENT_BUTTON.instantiate()
			
			button.text = tr(data.choose_text)
			button.reward_text = tr(data.choose_reward_text)
			
			buttons_vbox_container.add_child(button)
