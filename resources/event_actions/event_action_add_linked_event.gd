extends EventAction
class_name EventActionAddLinkedEvent

## Действие события - добавление связанного события.

@export var id: String

func play() -> void:
	if EventsManager.linked_events.has(id):
		Run.reserved_events_pool[id] = EventsManager.linked_events[id]
	else:
		printerr("EventActionAddLinkedEvent error: !EventsManager.linked_events.has(id), id is \"%s\"" % [id])
