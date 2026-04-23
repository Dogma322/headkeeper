extends PanelContainer

@onready var hp_bar: TextureProgressBar = %HpBar
@onready var hp_bar_label: Label = %HpBarLabel

func _ready() -> void:
	Signals.hero_health_changed.connect(_update_hp_bar.bind(true))
	_update_hp_bar.call_deferred(false)

var hp := 0:
	set(value):
		hp = value
		update_hp_bar()

var max_hp := 0:
	set(value):
		max_hp = value
		update_hp_bar()

func _update_hp_bar(smooth: bool):
	if smooth:
		update_hp_bar_smooth(Global.hero.health, Global.hero.max_health)
	else:
		hp = Global.hero.health
		max_hp = Global.hero.max_health

func update_hp_bar():
	hp_bar_label.text = str(hp) + "/" + str(max_hp)
	hp_bar.max_value = max_hp
	hp_bar.value = hp

func update_hp_bar_smooth(health, max_health):
	var tween = create_tween().set_parallel()
	tween.tween_property(self, "max_hp", max_health, 0.25)
	tween.tween_property(self, "hp", health, 0.25)
