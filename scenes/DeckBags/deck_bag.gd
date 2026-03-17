extends TextureButton

@onready var des_panel = $DesPanel
@onready var name_label = $DesPanel/NameLabel
@onready var des_label = $DesPanel/DesLabel
@onready var deck_label = $DeckLabel

var des_tween: Tween
var mouse_over_des = false

func _ready() -> void:
	update_labels()
	hide_des()

func _process(_delta: float) -> void:
	deck_label.text = str(DominoManager.temp_deck.size())

func show_des():
	update_labels()
	des_panel.visible = true
	
	if des_tween and des_tween.is_running():
		des_tween.kill()
	
	des_tween = get_tree().create_tween()
	des_tween.tween_property(des_panel, "modulate:a", 1, 0.15)

	
func hide_des():
	if not mouse_over_des: # не скрываем, если курсор снова вернулся
		if des_tween and des_tween.is_running():
			des_tween.kill()
		
		des_tween = get_tree().create_tween()
		des_tween.tween_property(des_panel, "modulate:a", 0, 0.15)
		await des_tween.finished
		if not mouse_over_des:
			des_panel.visible = false
	
func update_labels():
	name_label.text = tr("bone_bag_name")
	des_label.text = tr("bag_des") % DominoManager.temp_deck.size()



func _on_mouse_entered() -> void:
	mouse_over_des = true
	show_des()


func _on_mouse_exited() -> void:
	mouse_over_des = false
	hide_des()
