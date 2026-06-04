extends PanelContainer
class_name TopPanel

@onready var stage_label: Label = %StageLabel
@onready var health_points_label: Label = %HpLabel
@onready var gold_label: Label = %GoldLabel
@onready var skulls_label: Label = %SkullsLabel

@onready var map_button: IconButton = %MapButton
@onready var inventory_button: IconButton = %InventoryButton

var stage: int = 0:
	set(value):
		stage = value
		stage_label.text = tr("ID_STAGE") % [str(value)]

var disabled: bool = false:
	set(value):
		disabled = value
		map_button.disabled = value
		inventory_button.disabled = value

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

var heads := 0:
	set(value):
		heads = value


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
	
	Signals.reset_run_data.connect(reset)


## Сбрасывает значения в панели.
func reset() -> void:
	heads = Run.current_head_pool.size()

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


func _on_inventory_button_pressed() -> void:
	await Transition.blackout()
	SceneManager.show_inventory_scene()
