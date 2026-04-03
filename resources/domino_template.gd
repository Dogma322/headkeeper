extends Resource
class_name DominoTemplate

@export_range(1, 4) var a: int = 1
@export_range(1, 4) var b: int = 1

@export var a_type: String
@export var b_type: String

static var color_storage = {
	"RED": "red",
	"BLUE": "blue",
	"GREEN": "green"
}

static var type_to_color = {
	"attack": color_storage.RED,
	"attack2": color_storage.RED,
	"defense": color_storage.BLUE,
	"heal": color_storage.GREEN,
	"vulnerable": color_storage.GREEN,
	"weak": color_storage.GREEN,
	"draw": color_storage.GREEN,
	"corruption": color_storage.GREEN,
	"fury": color_storage.GREEN,
	"thorns": color_storage.GREEN,
	"empty_red": color_storage.RED,
	"empty_green": color_storage.GREEN,
	"empty_blue": color_storage.BLUE,
	"spear": color_storage.RED,
	"thorned_shield": color_storage.BLUE,
	"shield_strike": color_storage.RED,
	"shield": color_storage.BLUE,
	"repeat": color_storage.GREEN,
	"mace": color_storage.RED,
	"horn": color_storage.GREEN,
	"hammer": color_storage.RED,
	"crit": color_storage.GREEN,
	"dagger": color_storage.RED,
	"corrupted_stuff": color_storage.GREEN,
	"corrupted_sphere": color_storage.GREEN,
	"claws": color_storage.RED,
	"skull_4x": color_storage.RED,
}

static var type_to_string = {
	"attack": ["Attack"],
	"attack2": ["Attack"],
	"defense": ["Defense"],
	"heal": ["Skill"],
	"vulnerable": ["Skill"],
	"weak": ["Skill"],
	"draw": ["Skill"],
	"spear": ["Attack"],
	"thorned_shield": ["Skill", "Defense"],
	"shield_strike": ["Attack", "Defense"],
	"shield": ["Defense"],
	"repeat": ["Skill"],
	"mace": ["Attack"],
	"horn": ["Skill"],
	"hammer": ["Attack"],
	"crit": ["Skill"],
	"dagger": ["Attack"],
	"corrupted_stuff": ["Skill"],
	"corrupted_sphere": ["Skill"],
	"claws": ["Attack"],
	"skull_4x": ["Attack"],
}

static var color_to_modulate = {
	color_storage.RED : Color.html("#9A2743"),
	color_storage.BLUE : Color.html("#3E6D9E"),
	color_storage.GREEN : Color.html("#378D47"),
}

static var slot_to_tex = {
	1: preload("res://assets/Dominoes/Components/empty_1.atlastex"),
	2: preload("res://assets/Dominoes/Components/empty_2.atlastex"),
	3: preload("res://assets/Dominoes/Components/empty_3.atlastex"),
	4: preload("res://assets/Dominoes/Components/empty_4.atlastex"),
}

static var type_to_tex = {
	"attack": {
		1: preload("res://assets/Dominoes/Components/attack_1.atlastex"),
		2: preload("res://assets/Dominoes/Components/attack_2.atlastex"),
		3: preload("res://assets/Dominoes/Components/attack_3.atlastex"),
		4: preload("res://assets/Dominoes/Components/attack_4.atlastex"),
	},
	"attack2": {
		3: preload("res://assets/Dominoes/Components/attack2_3.atlastex"),
		4: preload("res://assets/Dominoes/Components/attack2_4.atlastex"),
	},
	"defense": {
		1: preload("res://assets/Dominoes/Components/defense_1.atlastex"),
		2: preload("res://assets/Dominoes/Components/defense_2.atlastex"),
		3: preload("res://assets/Dominoes/Components/defense_3.atlastex"),
		4: preload("res://assets/Dominoes/Components/defense_4.atlastex"),
	},
	"heal": {
		2: preload("res://assets/Dominoes/Components/heal_2.atlastex"),
		3: preload("res://assets/Dominoes/Components/heal_3.atlastex"),
	},
	"vulnerable": {
		2: preload("res://assets/Dominoes/Components/vulnerable_2.atlastex"),
	},
	"weak": {
		1: preload("res://assets/Dominoes/Components/weak_1.atlastex"),
		2: preload("res://assets/Dominoes/Components/weak_2.atlastex"),
	},
	"draw": {
		1: preload("res://assets/Dominoes/Components/dice_1.atlastex"),
	},
	"corruption": {
		2: preload("res://assets/Dominoes/Components/corruption_2.atlastex"),
		3: preload("res://assets/Dominoes/Components/corruption_3.atlastex"),
	},
	"fury": {
		1: preload("res://assets/Dominoes/Components/fury_1.atlastex"),
		2: preload("res://assets/Dominoes/Components/fury_2.atlastex"),
	},
	"thorns": {
		2: preload("res://assets/Dominoes/Components/thorns_2.atlastex"),
	},
	"empty_green": {
		2: preload("res://assets/Dominoes/Components/empty_green_2.atlastex"),
		3: preload("res://assets/Dominoes/Components/empty_green_3.atlastex"),
	},
	"empty_red": {
		2: preload("res://assets/Dominoes/Components/empty_red_2.atlastex"),
		3: preload("res://assets/Dominoes/Components/empty_red_3.atlastex"),
		4: preload("res://assets/Dominoes/Components/empty_red_4.atlastex"),
	},
	"empty_blue": {
		2: preload("res://assets/Dominoes/Components/empty_blue_2.tres"),
	},
	"spear": {
		1: preload("res://assets/Dominoes/Special/spear.atlastex"),
	},
	"thorned_shield": {
		1: preload("res://assets/Dominoes/Special/thorned_shield.atlastex"),
	},
	"shield_strike": {
		1: preload("res://assets/Dominoes/Special/shield_strike.atlastex"),
	},
	"shield": {
		1: preload("res://assets/Dominoes/Special/shield.atlastex"),
	},
	"repeat": {
		1: preload("res://assets/Dominoes/Special/repeat.atlastex"),
	},
	"mace": {
		1: preload("res://assets/Dominoes/Special/mace.atlastex"),
	},
	"horn": {
		1: preload("res://assets/Dominoes/Special/horn.atlastex"),
	},
	"hammer": {
		1: preload("res://assets/Dominoes/Special/hammer.atlastex"),
	}, 
	"crit": {
		1: preload("res://assets/Dominoes/Special/crit.atlastex"),
	},
	"dagger": {
		1: preload("res://assets/Dominoes/Special/dagger.atlastex"),
	},
	"corrupted_stuff": {
		1: preload("res://assets/Dominoes/Special/corrupted_stuff.atlastex"),
	},
	"corrupted_sphere": {
		1: preload("res://assets/Dominoes/Special/corrupted_sphere.atlastex"),
	},
	"claws": {
		2: preload("res://assets/Dominoes/Components/claws_2.atlastex")
	},
	"skull_4x": {
		4: preload("res://assets/Dominoes/Components/skull_4.atlastex"),
	}
}
