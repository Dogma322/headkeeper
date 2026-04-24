extends PanelContainer
class_name TopPanel

@onready var health_points_label: Label = %HpLabel
@onready var gold_label: Label = %GoldLabel
@onready var skulls_label: Label = %SkullsLabel

@onready var head_amount_label: Label = %HeadAmountLabel
@onready var bonus_amount_label: Label = %BonusAmountLabel
@onready var domino_amount_label: Label = %DominoAmountLabel

@onready var map_button: IconButton = %MapButton
@onready var domino_deck_button: IconButton = %DominoDeckButton


var selected_button = null

var health_points := 0:
	set(value):
		health_points = value
		update_hp_bar()

var max_health_points := 0:
	set(value):
		max_health_points = value
		update_hp_bar()

var gold := 0:
	set(value):
		gold = value
		gold_label.text = str(value)

var skulls := 0:
	set(value):
		skulls = value
		skulls_label.text = str(value)


func _ready() -> void:
	await get_tree().process_frame
	
	Signals.hero_health_changed.connect(func(): update_health_points_bar(Global.hero.health, Global.hero.max_health))
	health_points = Global.hero.health
	max_health_points = Global.hero.max_health
	
	Signals.gold_changed.connect(func(_gold: int): create_tween().tween_property(self, "gold", _gold, 0.25))
	gold = MoneyManager.gold
	
	Signals.skulls_changed.connect(func(_skulls: int): create_tween().tween_property(self, "skulls", _skulls, 0.25))
	skulls = MoneyManager.skulls
	
	domino_amount_label.text = str(DominoManager.deck.size())
	Signals.scene_changed.connect(_on_scene_changed)


func update_health_points_bar(health, max_health):
	var tween = create_tween().set_parallel()
	tween.tween_property(self, "max_hp", max_health, 0.25)
	tween.tween_property(self, "hp", health, 0.25)


func update_hp_bar():
	health_points_label.text = str(health_points) + "/" + str(max_health_points)


func _on_map_button_pressed() -> void:
	if SceneManager.current_scene == SceneManager.map_scene:
		return
	selected_button = map_button
	
	Transition.blackout_on()
	await get_tree().create_timer(1.0).timeout
	Transition.blackout_off()
	
	SceneManager.show_map_scene()


func _on_domino_deck_button_pressed() -> void:
	if SceneManager.current_scene == SceneManager.domino_list_scene and SceneManager.domino_list_scene.current_source == DominoListScene.Source.ALL:
		return
	selected_button = domino_deck_button
	SceneManager.show_domino_list_scene(DominoListScene.Source.ALL)


func _on_scene_changed():
	if SceneManager.current_scene == SceneManager.main_scene:
		if selected_button:
			selected_button.button_pressed = false
			selected_button = null
