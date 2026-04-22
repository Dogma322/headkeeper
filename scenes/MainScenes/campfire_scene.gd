extends Control
class_name CampfireScene

@onready var hp_bar: TextureProgressBar = %HpBar
@onready var hp_bar_label: Label = %HpBarLabel

func start() -> void:
	SceneManager.background.set_campfire_background()
	Signals.hero_health_changed.connect(_update_hp_bar)
	update_hp_bar(Global.hero.health, Global.hero.max_health)
	hp = Global.hero.health
	max_hp = Global.hero.max_health
	pass

func end():
	SceneManager.background.set_map_background()
	ActionCardManager.action_card_is_pressed = false
	

func _update_hp_bar():
	update_hp_bar_smooth(Global.hero.health, Global.hero.max_health)

var hp := 0:
	set(value):
		hp = value
		update_hp_bar(hp, max_hp)

var max_hp := 0:
	set(value):
		max_hp = value
		update_hp_bar(hp, max_hp)

func update_hp_bar(health, max_health):
	hp_bar_label.text = str(health) + "/" + str(max_health)
	hp_bar.max_value = max_health
	hp_bar.value = health

func update_hp_bar_smooth(health, max_health):
	var tween = create_tween()
	tween.tween_property(self, "max_hp", max_health, 0.25)
	tween.tween_property(self, "hp", health, 0.25)
