class_name SpecialDominoTemplate
extends DominoTemplate

@export var a_special_key := ""
@export var b_special_key := ""
@export var a_take_value_from_second := false
@export var b_take_value_from_second := false

static var special_type_to_color = {
	"spear": DominoColor.RED,
	"thorned_shield": DominoColor.BLUE,
}

static var special_type_to_string = {
	"spear": ["Attack"],
	"thorned_shield": ["Skill", "Defense"],
}

static var special_type_to_tex = {
	"spear": 
	{
		3: preload("res://assets/Dominoes/Special/spear.atlastex"),
	},
	"thorned_shield": {
		2: preload("res://assets/Dominoes/Special/thorned_shield.atlastex"),
	}
}
