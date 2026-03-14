extends Control

@onready var _name_label = $NameLabel
@onready var des_label = $DesLabel

@export_enum("Weak", "Fury", "Corruption", "Thorns", "Vulnerable", "Evasion") var type: String = "Weak"

func _ready() -> void:
	set_text()

func set_text():
	if type == "Weak":
		_name_label.text = tr("st_weak_name")
		des_label.text = tr("st_weak_des")
	if type == "Fury":
		_name_label.text = tr("st_strength_name")
		des_label.text = tr("st_strength_des")
	if type == "Corruption":
		_name_label.text = tr("st_corruption_name")
		des_label.text = tr("st_corruption_des")
	if type == "Thorns":
		_name_label.text = tr("st_thorns_name")
		des_label.text = tr("st_thorns_des")
	if type == "Vulnerable":
		_name_label.text = tr("st_vulnerable_name")
		des_label.text = tr("st_vulnerable_des")
	if type == "Evasion":
		_name_label.text = tr("st_evasion_name")
		des_label.text = tr("st_evasion_des")
