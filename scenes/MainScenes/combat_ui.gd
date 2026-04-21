extends Node2D
class_name CombatUI

## Текстовая метка для черепов.
@export var skulls_label: RichTextLabel

## Текстовая метка для золота.
@export var gold_label: RichTextLabel


## Устанавливает черепа в текстовую метку черепов.
func set_skulls(skulls: int) -> void:
	skulls_label.text = "[img]res://assets/Icons/CommonSkull.png[/img]%s" % str(skulls)


## Устанавливает золото в текстовую метку золота.
func set_gold(gold: int) -> void:
	gold_label.text = "%s" % str(gold)


func _ready() -> void:
	set_skulls(0)
	set_gold(0)
	Signals.skulls_changed.connect(set_skulls)
	Signals.gold_changed.connect(set_gold)
	pass


func _show_dominoes(mode: DominoListScene.Source) -> void:
	SceneManager.show_domino_list_scene(mode)


func _on_deck_bag_pressed() -> void:
	_show_dominoes(DominoListScene.Source.DECK_BAG)


func _on_discard_bag_pressed() -> void:
	_show_dominoes(DominoListScene.Source.DISCARD_BAG)


func _on_show_all_dominoes_btn_pressed() -> void:
	_show_dominoes(DominoListScene.Source.ALL)
