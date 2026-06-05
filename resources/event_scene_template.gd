extends Resource
class_name EventSceneTemplate

## Заголовок.
@export var title: String

## Описание.
@export var description: String

## Текстура.
@export var art: Texture2D

## Описание в кнопке выбора этой сцены.
@export var choose_text: String

## Описание награды в кнопке выбора этой сцены.
@export var choose_reward_text: String

## Под-сцены.
## Если пусто то создает одну кнопку - выхода.
@export var next: Array[EventSceneTemplate] = []

## Действия.
@export var actions: Array[EventAction] = []
