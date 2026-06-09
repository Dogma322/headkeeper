extends EventAction
class_name EventActionRemoveRandomDomino

## Действие события - удаление случайного домино.

const DOMINO = preload("uid://dnco2xl6pi07y")

var current_index := 0
var test_domino: Domino = null

func init() -> void:
	super()
	current_index = randi() % DominoManager.deck.size()


func init_button_tooltip(event_button: EventButton) -> void:
	super(event_button)
	
	if event_button:
		event_button.mouse_entered.connect(_on_mouse_entered.bind(event_button))
		event_button.mouse_exited.connect(_on_mouse_exited)


func _on_mouse_entered(event_button: EventButton) -> void:
	var domino: Domino = DominoManager.deck[current_index]
	
	test_domino = DOMINO.instantiate()
	SceneManager.event_scene.add_child(test_domino)
	test_domino.setup(Domino.SideSettings.new(domino.ab_types[0], domino.a_color), Domino.SideSettings.new(domino.ab_types[1], domino.b_color))
	
	test_domino.global_position = event_button.global_position + Vector2(event_button.size.x, 0) - Vector2(16, 32)


func _on_mouse_exited() -> void:
	if test_domino:
		test_domino.queue_free()
		test_domino = null


func play() -> void:
	var domino = DominoManager.deck[current_index]
	DominoManager.temp_deck.erase(domino)
	DominoManager.deck.erase(domino)
	domino.queue_free()
	Signals.deck_changed.emit()
