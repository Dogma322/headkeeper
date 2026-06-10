extends ScreenBase
class_name EventScene

@onready var title_label: RichTextLabel = %TitleLabel
@onready var description_rich_text_label: RichTextLabel = %DescriptionRichTextLabel
@onready var buttons_vbox_container: VBoxContainer = %ButtonsVBoxContainer

const EVENT_BUTTON = preload("uid://bemk37cis2wkk")

var current_event_scene: EventSceneTemplate

func start_event(event: EventTemplate) -> void:
	assert(event)
	assert(event.event_scene)
	
	start_event_scene(event.event_scene)


func start() -> void:
	if current_event_scene and current_event_scene.art:
		SceneManager.background.texture = current_event_scene.art
	else:
		SceneManager.background.set_map_background()


func end_event() -> void:
	current_event_scene = null
	Signals.event_ended.emit()


func start_event_scene(event_scene: EventSceneTemplate) -> void:
	# Проиграем действия события.
	var pass_to_screen := false
	
	for action: EventAction in event_scene.actions:
		if action and not action.applied:
			if action.pass_to_screen:
				pass_to_screen = true
				
				Transition.blackout_on()
				await get_tree().create_timer(1.0).timeout
				Transition.blackout_off()
			action.play()
			action.applied = true
	
	if event_scene.next.is_empty():
		if not pass_to_screen:
			end_event()
		
		#var button: EventButton = EVENT_BUTTON.instantiate()
		#button.text = "[color=gold]%s[/color]" % tr("EVENT_EXIT_BTN")
		#button.pressed.connect(end_event)
		#buttons_vbox_container.add_child(button)
	else:
		current_event_scene = event_scene
	
		title_label.text = "[color=gold]%s[/color]" % tr(event_scene.title)
		description_rich_text_label.text = tr(event_scene.description)
	
		if event_scene.art:
			SceneManager.background.texture = event_scene.art
		else:
			SceneManager.background.set_map_background()
		
		# Очистим предыдущие кнопки.
		for btn in buttons_vbox_container.get_children():
			btn.queue_free()
		
		for data in event_scene.next:
			if data == null:
				continue
			
			for action: EventAction in data.actions:
				if action:
					action.init()
			
			var button: EventButton = EVENT_BUTTON.instantiate()
			for action: EventAction in data.actions:
				if action:
					action.init_button_tooltip(button)
			
			button.text = "[color=gold]%s[/color]" % tr(data.choose_text)
			button.reward_text = tr(data.choose_reward_text)
			button.pressed.connect(start_event_scene.bind(data))
			
			buttons_vbox_container.add_child(button)
