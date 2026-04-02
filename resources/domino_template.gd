extends Resource
class_name DominoTemplate

@export_range(1, 4) var a: int = 1
@export_range(1, 4) var b: int = 1

enum DominoType {
	NONE,
	ATTACK,
	ATTACK2,
	DEFENSE,
	HEAL,
	VULNERABLE,
	WEAK,
	DRAW,
	CORRUPTION,
	FURY,
	THORNS,
	EMPTY_GREEN,
	EMPTY_BLUE,
	
	SPEAR,
	THORNED_SHIELD,
	SHIELD_STRIKE
}

@export var a_type: DominoType
@export var b_type: DominoType

enum DominoColor {
	RED,
	BLUE,
	GREEN,
}

static var type_to_color = {
	DominoType.ATTACK: DominoColor.RED,
	DominoType.ATTACK2: DominoColor.RED,
	DominoType.DEFENSE: DominoColor.BLUE,
	DominoType.HEAL: DominoColor.GREEN,
	DominoType.VULNERABLE: DominoColor.GREEN,
	DominoType.WEAK: DominoColor.GREEN,
	DominoType.DRAW: DominoColor.GREEN,
	DominoType.CORRUPTION: DominoColor.GREEN,
	DominoType.FURY: DominoColor.GREEN,
	DominoType.THORNS: DominoColor.GREEN,
	#DominoType.EMPTY_RED: DominoColor.RED,
	DominoType.EMPTY_GREEN: DominoColor.GREEN,
	DominoType.EMPTY_BLUE: DominoColor.BLUE,
	DominoType.SPEAR: DominoColor.RED,
	DominoType.THORNED_SHIELD: DominoColor.BLUE,
	DominoType.SHIELD_STRIKE: DominoColor.RED,
}

static var type_to_string = {
	DominoType.ATTACK: ["Attack"],
	DominoType.ATTACK2: ["Attack"],
	DominoType.DEFENSE: ["Defense"],
	DominoType.HEAL: ["Skill"],
	DominoType.VULNERABLE: ["Skill"],
	DominoType.WEAK: ["Skill"],
	DominoType.DRAW: ["Skill"],
	DominoType.SPEAR: ["Attack"],
	DominoType.THORNED_SHIELD: ["Skill", "Defense"],
	DominoType.SHIELD_STRIKE: ["Attack", "Defense"],
}

static var color_to_block_top_tex = {
	DominoColor.RED: preload("res://assets/Dominoes/Blocks/top_red_block.atlastex"),
	DominoColor.BLUE: preload("res://assets/Dominoes/Blocks/top_blue_block.atlastex"),
	DominoColor.GREEN: preload("res://assets/Dominoes/Blocks/top_green_block.atlastex"),
}

static var color_to_block_bot_tex = {
	DominoColor.RED: preload("res://assets/Dominoes/Blocks/bot_red_block.atlastex"),
	DominoColor.BLUE: preload("res://assets/Dominoes/Blocks/bot_blue_block.atlastex"),
	DominoColor.GREEN: preload("res://assets/Dominoes/Blocks/bot_green_block.atlastex"),
}

static var type_to_tex = {
	DominoType.ATTACK: {
		1: preload("res://assets/Dominoes/Components/attack_1.atlastex"),
		2: preload("res://assets/Dominoes/Components/attack_2.atlastex"),
		3: preload("res://assets/Dominoes/Components/attack_3.atlastex"),
		4: preload("res://assets/Dominoes/Components/attack_4.atlastex"),
	},
	DominoType.ATTACK2: {
		3: preload("res://assets/Dominoes/Components/attack2_3.atlastex"),
		4: preload("res://assets/Dominoes/Components/attack2_4.atlastex"),
	},
	DominoType.DEFENSE: {
		1: preload("res://assets/Dominoes/Components/defense_1.atlastex"),
		2: preload("res://assets/Dominoes/Components/defense_2.atlastex"),
		3: preload("res://assets/Dominoes/Components/defense_3.atlastex"),
		4: preload("res://assets/Dominoes/Components/defense_4.atlastex"),
	},
	DominoType.HEAL: {
		2: preload("res://assets/Dominoes/Components/heal_2.atlastex"),
		3: preload("res://assets/Dominoes/Components/heal_3.atlastex"),
	},
	DominoType.VULNERABLE: {
		2: preload("res://assets/Dominoes/Components/vulnerable_2.atlastex"),
	},
	DominoType.WEAK: {
		1: preload("res://assets/Dominoes/Components/weak_1.atlastex"),
		2: preload("res://assets/Dominoes/Components/weak_2.atlastex"),
	},
	DominoType.DRAW: {
		1: preload("res://assets/Dominoes/Components/dice_1.atlastex"),
	},
	DominoType.CORRUPTION: {
		2: preload("res://assets/Dominoes/Components/corruption_2.atlastex"),
		3: preload("res://assets/Dominoes/Components/corruption_3.atlastex"),
	},
	DominoType.FURY: {
		1: preload("res://assets/Dominoes/Components/fury_1.atlastex"),
		2: preload("res://assets/Dominoes/Components/fury_2.atlastex"),
	},
	DominoType.THORNS: {
		2: preload("res://assets/Dominoes/Components/thorns_2.atlastex"),
	},
	DominoType.EMPTY_GREEN: {
		2: preload("res://assets/Dominoes/Components/empty_green_2.atlastex"),
		3: preload("res://assets/Dominoes/Components/empty_green_3.atlastex"),
	},
	#DominoType.EMPTY_RED: {
		#2: preload("res://assets/Dominoes/Components/empty_red_2.atlastex"),
		#3: preload("res://assets/Dominoes/Components/empty_red_3.atlastex"),
		#4: preload("res://assets/Dominoes/Components/empty_red_4.atlastex"),
	#},
	DominoType.EMPTY_BLUE: {
		2: preload("res://assets/Dominoes/Components/empty_blue_2.tres"),
	},
	DominoType.SPEAR: {
		1: preload("res://assets/Dominoes/Special/spear.atlastex"),
	},
	DominoType.THORNED_SHIELD: {
		1: preload("res://assets/Dominoes/Special/thorned_shield.atlastex"),
	},
	DominoType.SHIELD_STRIKE: {
		1: preload("res://assets/Dominoes/Special/shield_strike.atlastex"),
	}
}
