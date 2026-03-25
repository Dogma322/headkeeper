extends Node2D
class_name CombatUI

## Текстовая метка для денег.
@export var money_label: RichTextLabel
@export var domino_list_scene: DominoListScene


## Устанавливает деньги в текстовую метку денег.
func set_money(amount: int) -> void:
	money_label.text = str(amount)


func _ready() -> void:
	Signals.money_changed.connect(set_money)
	pass


func _show_dominoes(mode: DominoListScene.Source) -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	Transition.blackout_off()
	Global.fight_scene.hide_ui()
	domino_list_scene.show()
	domino_list_scene.update_domino_list(mode)


func _on_deck_bag_pressed() -> void:
	_show_dominoes(DominoListScene.Source.DECK_BAG)


func _on_discard_bag_pressed() -> void:
	_show_dominoes(DominoListScene.Source.DISCARD_BAG)


func _on_show_all_dominoes_btn_pressed() -> void:
	_show_dominoes(DominoListScene.Source.ALL)
