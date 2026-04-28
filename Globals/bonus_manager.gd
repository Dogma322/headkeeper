extends Node

var bonus_templates = {
	"attack5": preload("res://resources/bonuses/bonus_attack5.tres"),
	"defense4": preload("res://resources/bonuses/bonus_defense4.tres"),
	"heal3": preload("res://resources/bonuses/bonus_heal3.tres"),
	"weak": preload("res://resources/bonuses/bonus_weak.tres"),
}

var bonus_effects = {
	"h_5dmg_bonus": preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_5_damage.tscn"),
	"h_4def_bonus": preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_4_defense.tscn"),
	"h_3heal": preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_heal.tscn"),
	"h_1weak": preload("res://scenes/BoardBonuses/HeroBonuses/bb_h_1_weak.tscn")
}
