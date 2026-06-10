extends Resource
class_name EventTemplate

## Шаблон события.

## Имя события.
@export var name_str: String

## Акт в котором событие происходит.
@export_range(1, 4) var act = 1

## Начальная сцена события.
@export var event_scene: EventSceneTemplate
