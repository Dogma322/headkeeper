extends Node2D
class_name CombatUI

## Текстовая метка для денег.
@export var money_label: RichTextLabel
@export var domino_list_scene: DominoListScene


## Устанавливает деньги в текстовую метку денег.
func set_money(amount: int) -> void:
	money_label.text = "[img]res://assets/Icons/CommonSkull.png[/img]%s" % str(amount)


func _ready() -> void:
	set_money(0)
	Signals.money_changed.connect(set_money)
	pass


func _show_dominoes(mode: DominoListScene.Source) -> void:
	SceneManager.show_domino_list_scene(mode)


func _on_deck_bag_pressed() -> void:
	_show_dominoes(DominoListScene.Source.DECK_BAG)


func _on_discard_bag_pressed() -> void:
	_show_dominoes(DominoListScene.Source.DISCARD_BAG)


func _on_show_all_dominoes_btn_pressed() -> void:
	_show_dominoes(DominoListScene.Source.ALL)
