extends ScreenBase
class_name CraftScene

const COLUMNS := 8
const SPACING := Vector2(40, 70)  # расстояние между домино

# НАСТРОЙКА ВЫСОТЫ СЕТКИ
@export var CENTER_Y := 120

@onready var accept_button: GameButton = %AcceptButton
@onready var skip_button: GameButton = %SkipButton

@onready var reroll_button: GameButton = %RerollButton
@onready var board_craft: Board = $BoardCraft
@onready var dominoes = $Dominoes
@onready var battle_background: TextureRect = $BattleBackground
@onready var text_panel: TextPanel = %TextPanel
@onready var tooltips_box: VBoxContainer = %TooltipsBox
const TOOLTIP_PANEL = preload("uid://cbpouqrfw2p2t")

@onready var symbol_pool = [
	"attack",
	"attack2",
	"claws",
	"corruption",
	"corrupted_sphere",
	"corrupted_stuff",
	"crit",
	"dagger",
	"defense",
	"draw",
	"fury",
	"hammer",
	"heal",
	"horn",
	"mace",
	"repeat",
	"shield",
	"shield_strike",
	"skull",
	"spear",
	"thorns",
	"thorned_shield",
	"vulnerable",
	"weak",
]

var color_pool = ["red", "blue", "green"]
var color_pool_loc = { "red": "Красный", "blue": "Синий", "green": "Зеленый"}

var current_domino: Domino = null

var domino_parents = []
var domino_buffer = []
var domino_prev_transforms = []
var current_reroll_cost := 0:
	set(value):
		current_reroll_cost = value
		reroll_button.text = "Reroll %s[img]res://assets/Icons/TopPanelIcons/coin_icon.atlastex[/img]" % str(value)

var reroll_tween: Tween

enum CraftType {
	UNKNOWN,
	NUMBER,
	SYMBOL,
	COLOR,
	MAX
}

var current_craft_type := CraftType.UNKNOWN
var current_amount := 0
var current_type := ""
var demo_mode := false

const REROLL_INC = 5

func get_current_side() -> int:
	if current_domino:
		return current_domino.initial_connected_side
	return 0


func _ready() -> void:
	Signals.domino_added_to_board.connect(_on_domino_added_to_board)
	Signals.domino_chain_removed.connect(_on_domino_chain_removed)


func start_demo():
	demo_mode = true
	battle_background.show()
	current_reroll_cost = 0


func start():
	demo_mode = false
	battle_background.hide()
	
	Global.hand.draw_all_dominoes()
	accept_button.disabled = true
	
	current_reroll_cost = 0
	reroll()
	current_reroll_cost = REROLL_INC
	if Run.gold - current_reroll_cost < 0:
		reroll_button.disabled = true
	else:
		reroll_button.disabled = false
	skip_button.disabled = false

func clear_tooltips() -> void:
	tooltips_box.hide()
	for child in tooltips_box.get_children():
		child.queue_free()

func reroll_specified(craft_type):
	current_craft_type = craft_type
	clear_tooltips()
	match craft_type:
		CraftType.NUMBER:
			current_amount = randi_range(1, 4)
			current_type = ""
			text_panel.text = tr("craft_change_number") % current_amount
		CraftType.SYMBOL:
			current_amount = randi_range(1, 4)
			symbol_pool.shuffle()
			current_type = symbol_pool[0]
			text_panel.text = tr("craft_change_symbols") % [current_amount, DominoSideVisual.get_type_texture(current_type, "red").resource_path]
			tooltips_box.show()
			
			var tooltip: TooltipPanel = TOOLTIP_PANEL.instantiate()
			tooltips_box.add_child(tooltip)
			tooltip.description = get_tooltip_for_type(current_type)
		CraftType.COLOR:
			color_pool.shuffle()
			current_type = color_pool[0]
			text_panel.text = tr("craft_change_color") % color_pool_loc[current_type]


func reroll() -> void:
	if reroll_tween and reroll_tween.is_running():
		return
	
	if Run.gold - current_reroll_cost >= 0:
		reroll_specified(randi_range(1, CraftType.MAX - 1) as CraftType)
		
		if Run.gold - current_reroll_cost == 0:
			reroll_button.disabled = true
		
		reroll_tween = create_tween()
		reroll_tween.tween_property(Run, "gold", Run.gold - current_reroll_cost, 0.25)
		
		current_reroll_cost += REROLL_INC


func _on_exit_button_pressed() -> void:
	Global.hand.discard_all_dominoes()
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	Transition.blackout_off()
	DominoManager.reset()
	hide()
	
	SceneManager.main_scene = null
	Global.meta_scene.show()


func apply(craft_type : CraftType, type: String, amount: int) -> void:
	var side := get_current_side()
	match craft_type:
		CraftType.NUMBER:
			var slots = PackedStringArray()
			var symbols: PackedStringArray = current_domino.ab_types[side]
			for i in range(amount):
				if i < symbols.size():
					slots.push_back(symbols[i])
				else:
					slots.push_back("empty")
			if side == 0:
				current_domino.setup(Domino.SideSettings.new(slots), null)
			else:
				current_domino.setup(null, Domino.SideSettings.new(slots))
		CraftType.SYMBOL:
			var max_count = current_domino.ab_types[side].size()
			for i in range(min(amount, max_count)):
				current_domino.push_symbol(side, type, i)
		CraftType.COLOR:
			if side == 0:
				current_domino.a_color = type
			else:
				current_domino.b_color = type


func finish():
	disable_buttons(true)
	reroll_button.disabled = true
	skip_button.disabled = true
	DominoManager.block_domino_input = true
	await get_tree().create_timer(1.0).timeout
	Global.hand.discard_all_dominoes()
	if demo_mode:
		DominoManager.reshuffle_discard_into_deck()
		
		Transition.blackout_on()
		await get_tree().create_timer(1.0).timeout
		Transition.blackout_off()
		
		SceneManager.show_map_scene()
		SceneManager.map_scene.reset()
	else:
		Signals.domino_selected.emit()


func _on_accept_button_pressed() -> void:
	if current_domino != null:
		apply(current_craft_type, current_type, current_amount)
		finish()


func _on_change_number_button_pressed() -> void:
	apply(CraftType.NUMBER, "", randi_range(1, 4))


func _on_add_random_symbol_button_pressed() -> void:
	symbol_pool.shuffle()
	apply(CraftType.SYMBOL, symbol_pool[0], 1)


func _on_remove_random_symbol_button_pressed() -> void:
	var side := get_current_side()
	var indexes := []
	var i := 0
	for type in current_domino.ab_types[side]:
		if type != "empty":
			indexes.push_back(i)
		i += 1
	if indexes.size() == 0:
		return
	if indexes.size() > 1:
		indexes.shuffle()
	current_domino.remove_symbol(side, indexes[0]) 


func _on_change_color_button_pressed() -> void:
	apply(CraftType.COLOR, color_pool[0], 0)


func _on_reroll_button_pressed() -> void:
	reroll_specified(2)
	#reroll()


func _on_skip_button_pressed() -> void:
	finish()


func disable_buttons(disable: bool) -> void:
	accept_button.disabled = disable


func _on_domino_added_to_board(domino) -> void:
	disable_buttons(false)
	current_domino = domino


func _on_domino_chain_removed() -> void:
	disable_buttons(true)
	current_domino = null

func get_tooltip_for_type(key: String) -> String:
	var extra_key = ""
	var text = ""

	match key:
		"attack", "attack2":
			text = TextFormatter.highlight_keywords(tr("DM_ATTACK_1_DESC"))
		"corruption":
			extra_key = "Corruption"
			text = TextFormatter.highlight_keywords(tr("DM_CORRUPTION_1_DESC"))
		"defense":
			text = TextFormatter.highlight_keywords(tr("DM_DEFENSE_1_DESC"))
		"draw":
			text = TextFormatter.highlight_keywords(tr("DM_DRAW_1_DESC"))
		"fury":
			extra_key = "Fury"
			text = TextFormatter.highlight_keywords(tr("DM_FURY_1_DESC"))
		"heal":
			text = TextFormatter.highlight_keywords(tr("DM_HEAL_1_DESC"))
		"vulnerable":
			extra_key = "Vulnerable"
			text = TextFormatter.highlight_keywords(tr("DM_VULNERABLE_1_DESC"))
		"weak":
			extra_key = "Weak"
			text = TextFormatter.highlight_keywords(tr("DM_WEAK_1_DESC"))
		"thorns":
			extra_key = "Thorns"
			text = TextFormatter.highlight_keywords(tr("DM_THORNS_1_DESC"))
		"spear":
			text = TextFormatter.highlight_keywords(tr("DM_SPEAR_1_DESC"))
		"thorned_shield":
			text = TextFormatter.highlight_keywords(tr("DM_THORNED_SHIELD_1_DESC"))
		"shield_strike":
			text = TextFormatter.highlight_keywords(tr("DM_SHIELD_STRIKE_1_DESC"))
		"shield":
			text = TextFormatter.highlight_keywords(tr("DM_STEEL_SHIELD_1_DESC"))
		"repeat":
			text = TextFormatter.highlight_keywords(tr("DM_REPEAT_1_DESC"))
		"mace":
			text = TextFormatter.highlight_keywords(tr("DM_MACE_1_DESC"))
		"horn":
			text = TextFormatter.highlight_keywords(tr("DM_HORN_1_DESC"))
		"hammer":
			text = TextFormatter.highlight_keywords(tr("DM_HAMMER_1_DESC"))
		"crit":
			text = TextFormatter.highlight_keywords(tr("DM_CRIT_1_DESC"))
		"dagger":
			text = TextFormatter.highlight_keywords(tr("DM_DAGGER_1_DESC"))
		"corrupted_stuff":
			text = TextFormatter.highlight_keywords(tr("DM_DARK_STAFF_1_DESC"))
		"corrupted_sphere":
			text = TextFormatter.highlight_keywords(tr("DM_DARK_SPHERE_1_DESC"))
		"claws":
			text = TextFormatter.highlight_keywords(tr("DM_CLAWS_1_DESC"))
		"skull":
			return TextFormatter.highlight_keywords(tr("DM_4VAL_ATTACK_1_DESC"))
	if not extra_key.is_empty():
		var extra_tooltip: AdditionalTooltipPanel = Domino.ADDITIONAL_TOOLTIP_PANEL.instantiate()
		extra_tooltip.type = extra_key
		tooltips_box.add_child(extra_tooltip)
	
	
	
	if DominoSideVisual.type_to_tex.has(key):
		return "[img]%s[/img] - %s" % [DominoSideVisual.type_to_tex[key]["red"].resource_path, text]
	elif DominoSideVisual.special_to_tex.has(key):
		return "[img]%s[/img] - %s" % [DominoSideVisual.special_to_tex[key].resource_path, text]
	
	return text
