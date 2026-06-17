extends Node

var bonus_templates: Dictionary = {
	"attack5": preload("res://resources/bonuses/bonus_attack5.tres"),
	"crit": preload("res://resources/bonuses/bonus_crit.tres"),
	"defense4": preload("res://resources/bonuses/bonus_defense4.tres"),
	"draw": preload("res://resources/bonuses/bonus_draw.tres"),
	"heal3": preload("res://resources/bonuses/bonus_heal3.tres"),
	"repeat": preload("res://resources/bonuses/bonus_repeat.tres"),
	"vulnerable": preload("res://resources/bonuses/bonus_vulnerable.tres"),
	"weak": preload("res://resources/bonuses/bonus_weak.tres"),
}

var special_bonus_templates: Dictionary = {
	"fury": preload("res://resources/bonuses/special/bonus_fury.tres"),
	"fireball": preload("res://resources/bonuses/special/bonus_fireball.tres"),
	"vampire_fang": preload("res://resources/bonuses/special/bonus_vampire_fang.tres"),
}

var bonus_effects: Dictionary = {
	# bonus_templates
	
	"h_5dmg_bonus": preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_5_damage.tscn"),
	"h_1crit": preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_1_crit.tscn"),
	"h_4def_bonus": preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_4_defense.tscn"),
	"h_1draw": preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_1_draw.tscn"),
	"h_3heal": preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_3_heal.tscn"),
	"h_1repeat": preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_1_repeat.tscn"),
	"h_1vulnerable": preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_1_vulnerable.tscn"),
	"h_1weak": preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_1_weak.tscn"),
	
	# special_bonus_templates
	
	"h_1fireball": preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_1_fireball.tscn"),
	"h_1fury": preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_1_fury.tscn"),
	"h_1vampire_fang": preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_1_vampire_fang.tscn")
}
