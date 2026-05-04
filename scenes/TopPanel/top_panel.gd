extends PanelContainer
class_name TopPanel

@onready var health_points_label: Label = %HpLabel
@onready var gold_label: Label = %GoldLabel
@onready var skulls_label: Label = %SkullsLabel

@onready var head_amount_label: Label = %HeadAmountLabel
@onready var bonus_amount_label: Label = %BonusAmountLabel
@onready var domino_amount_label: Label = %DominoAmountLabel

@onready var map_button: IconButton = %MapButton
@onready var head_deck_button: IconButton = %HeadDeckButton
@onready var bonus_deck_button: IconButton = %BonusDeckButton
@onready var domino_deck_button: IconButton = %DominoDeckButton

var disabled: bool = false:
	set(value):
		disabled = value
		map_button.disabled = value
		head_deck_button.disabled = value
		bonus_deck_button.disabled = value
		domino_deck_button.disabled = value


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

var bonuses := 0:
	set(value):
		bonuses = value
		bonus_amount_label.text = str(bonuses)

var heads := 0:
	set(value):
		heads = value
		head_amount_label.text = str(heads)

func _ready() -> void:
	disabled = true
	await get_tree().process_frame
	
	Signals.hero_health_changed.connect(func(): update_health_points_bar(Global.hero.health, Global.hero.max_health))
	health_points = Global.hero.health
	max_health_points = Global.hero.max_health
	
	Signals.gold_changed.connect(func(_gold: int): create_tween().tween_property(self, "gold", _gold, 0.25))
	gold = Run.gold
	
	Signals.skulls_changed.connect(func(_skulls: int): create_tween().tween_property(self, "skulls", _skulls, 0.25))
	skulls = Run.skulls
	
	domino_amount_label.text = str(DominoManager.deck.size())
	
	Signals.head_amount_changed.connect(update_heads_counter)
	update_heads_counter()
	
	Signals.bonus_amount_changed.connect(update_bonuses_counter)
	update_bonuses_counter()
	
	Signals.reset_run_data.connect(reset)


## Сбрасывает значения в панели.
func reset() -> void:
	heads = Run.current_head_pool.size()


## Обновляет кол-во голов.
func update_heads_counter() -> void:
	heads = Run.current_head_pool.size()


## Обновляет кол-во бонусов.
func update_bonuses_counter() -> void:
	bonuses = BoardManager.bonus_pool.size()


func update_health_points_bar(health, max_health):
	var tween = create_tween().set_parallel()
	tween.tween_property(self, "max_health_points", max_health, 0.25)
	tween.tween_property(self, "health_points", health, 0.25)


func update_hp_bar():
	health_points_label.text = str(health_points) + "/" + str(max_health_points)


func _on_map_button_pressed() -> void:
	if SceneManager.current_scene == SceneManager.map_scene:
		return
	
	await Transition.blackout()
	SceneManager.show_map_scene()


func _on_domino_deck_button_pressed() -> void:
	if SceneManager.current_scene != SceneManager.item_list_scene:
		await Transition.blackout()
	SceneManager.show_domino_list_scene(ItemListScene.DominoSource.ALL)


func _on_bonus_deck_button_pressed() -> void:
	if SceneManager.current_scene != SceneManager.item_list_scene:
		await Transition.blackout()
	SceneManager.show_bonus_list_scene()


func _on_head_deck_button_pressed() -> void:
	if SceneManager.current_scene != SceneManager.item_list_scene:
		await Transition.blackout()
	SceneManager.show_head_list_scene()
