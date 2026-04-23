extends Node2D
class_name CombatUI


func _ready() -> void:
	pass


func _show_dominoes(mode: DominoListScene.Source) -> void:
	SceneManager.show_domino_list_scene(mode)


func _on_deck_bag_pressed() -> void:
	_show_dominoes(DominoListScene.Source.DECK_BAG)


func _on_discard_bag_pressed() -> void:
	_show_dominoes(DominoListScene.Source.DISCARD_BAG)


func _on_show_all_dominoes_btn_pressed() -> void:
	_show_dominoes(DominoListScene.Source.ALL)
