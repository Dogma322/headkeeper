extends Control

const COLUMNS := 8
const SPACING := Vector2(40, 70)  # расстояние между домино

# НАСТРОЙКА ВЫСОТЫ СЕТКИ
@export var CENTER_Y := 120

@onready var exit_button: TextureButton = %ExitButton
@onready var accept_button: GameButton = %AcceptButton
@onready var reroll_button: GameButton = %RerollButton
@onready var cost_label: RichTextLabel = %CostLabel
@onready var board_craft: Board = $BoardCraft
@onready var change_number_button: GameButton = %ChangeNumberButton
@onready var add_random_symbol_button: GameButton = %AddRandomSymbolButton
@onready var remove_random_symbol_button: GameButton = %RemoveRandomSymbolButton
@onready var change_color_button: GameButton = %ChangeColorButton
@onready var dominoes = $Dominoes
@onready var battle_background: Node2D = $BattleBackground
@onready var text_panel: TextPanel = %TextPanel

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


func get_current_side() -> int:
	if current_domino:
		return 1 if current_domino.initial_connected_side == 0 else 0
	return 0


func _ready() -> void:
	Transition.blackout_off()
	if not is_instance_valid(Global.fight_scene):
		exit_button.show()
		battle_background.show()
		accept_button.hide()
	
	Hand.draw_all_dominoes()
	accept_button.disabled = true
	reroll_button.disabled = true
	change_number_button.disabled = true
	add_random_symbol_button.disabled = true
	remove_random_symbol_button.disabled = true
	change_color_button.disabled = true
	Signals.domino_added_to_board.connect(_on_domino_added_to_board)
	Signals.domino_chain_removed.connect(_on_domino_chain_removed)
	
	reroll()


func reroll() -> void:
	current_craft_type = randi_range(1, CraftType.MAX - 1) as CraftType
	match current_craft_type:
		CraftType.NUMBER:
			current_amount = randi_range(1, 4)
			current_type = ""
			text_panel.text = tr("craft_change_number") % current_amount
		CraftType.SYMBOL:
			current_amount = randi_range(1, 4)
			symbol_pool.shuffle()
			current_type = symbol_pool[0]
			text_panel.text = tr("craft_change_symbols") % [current_amount, DominoSideVisual.get_type_texture(current_type, "red").resource_path]
		CraftType.COLOR:
			color_pool.shuffle()
			current_type = color_pool[0]
			text_panel.text = tr("craft_change_color") % color_pool_loc[current_type]


func _on_exit_button_pressed() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	DominoManager.reset()
	get_tree().change_scene_to_file("res://scenes/MainScenes/main_menu.tscn")


func apply(craft_type : CraftType, type: String, amount: int) -> void:
	var side := get_current_side()
	match craft_type:
		CraftType.NUMBER:
			var slots = PackedStringArray()
			for i in range(amount):
				slots.push_back("empty")
			if current_domino.initial_connected_side == 1:
				current_domino.setup(Domino.SideSettings.new(slots), null)
			else:
				current_domino.setup(null, Domino.SideSettings.new(slots))
		CraftType.SYMBOL:
			for i in range(amount):
				current_domino.push_symbol(side, type)
		CraftType.COLOR:
			if side == 0:
				current_domino.a_color = type
			else:
				current_domino.b_color = type

func _on_accept_button_pressed() -> void:
	if current_domino != null:
		apply(current_craft_type, current_type, current_amount)
		await get_tree().create_timer(2.0).timeout
		Hand.discard_all_dominoes()
		Signals.domino_selected.emit()


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
	reroll()


func _on_domino_added_to_board(domino) -> void:
	reroll_button.disabled = false
	change_number_button.disabled = false
	add_random_symbol_button.disabled = false
	remove_random_symbol_button.disabled = false
	change_color_button.disabled = false
	accept_button.disabled = false
	current_domino = domino


func _on_domino_chain_removed() -> void:
	accept_button.disabled = true
	reroll_button.disabled = true
	change_number_button.disabled = true
	add_random_symbol_button.disabled = true
	remove_random_symbol_button.disabled = true
	change_color_button.disabled = true
	current_domino = null
