@tool
extends TooltipPanel
class_name AdditionalTooltipPanel

@export_enum("Weak", "Fury", "Corruption", "Thorns", "Vulnerable", "Evasion") var type: String = "Weak":
	set(value):
		type = value
		set_text()

func _ready() -> void:
	super()
	set_text()

func set_text():
	if type == "Weak":
		caption = tr("st_weak_name")
		description = tr("st_weak_des")
	if type == "Fury":
		caption = tr("st_strength_name")
		description = tr("st_strength_des")
	if type == "Corruption":
		caption = tr("st_corruption_name")
		description = tr("st_corruption_des")
	if type == "Thorns":
		caption = tr("st_thorns_name")
		description = tr("st_thorns_des")
	if type == "Vulnerable":
		caption = tr("st_vulnerable_name")
		description = tr("st_vulnerable_des")
	if type == "Evasion":
		caption = tr("st_evasion_name")
		description = tr("st_evasion_des")
