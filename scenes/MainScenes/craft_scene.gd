extends Control

@onready var money_label: RichTextLabel = %MoneyLabel
@onready var exit_button: TextureButton = %ExitButton
@onready var accept_button: GameButton = %AcceptButton
@onready var reroll_button: GameButton = %RerollButton
@onready var cost_label: RichTextLabel = %CostLabel
@onready var board_craft: Board = $BoardCraft
@onready var change_number_button: GameButton = %ChangeNumberButton
@onready var add_random_symbol_button: GameButton = %AddRandomSymbolButton
@onready var remove_random_symbol_button: GameButton = %RemoveRandomSymbolButton
@onready var change_color_button: GameButton = %ChangeColorButton

@onready var symbol_pool = [
	"attack",
	"attack2",
	"claws",
	"dagger",
	"defense",
	"hammer",
	"heal",
	"mace",
	"shield",
	"skull",
	"spear",
	"thorned_shield",
]

var colors = ["red", "blue", "green"]

var current_domino: Domino = null

func get_current_side() -> int:
	if current_domino:
		return 1 if current_domino.initial_connected_side == 0 else 0
	return 0

func _ready() -> void:
	Transition.blackout_off()
	money_label.text = "[img]res://assets/Icons/CommonSkull.png[/img]%s" % [str(MetaManager.money)]
	Hand.draw_dominoes()
	accept_button.disabled = true
	reroll_button.disabled = true
	change_number_button.disabled = true
	add_random_symbol_button.disabled = true
	remove_random_symbol_button.disabled = true
	change_color_button.disabled = true
	Signals.domino_added_to_board.connect(_on_domino_added_to_board)
	Signals.domino_chain_removed.connect(_on_domino_chain_removed)


func _on_exit_button_pressed() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	DominoManager.reset()
	get_tree().change_scene_to_file("res://scenes/MainScenes/main_menu.tscn")


func _on_accept_button_pressed() -> void:
	pass # Replace with function body.


func _on_change_number_button_pressed() -> void:
	assert(current_domino != null)
	var value := 0
	var count = current_domino.a if current_domino.initial_connected_side == 1 else current_domino.b
	while value == 0 or count == value:
		value = 1 + randi() % 4
	var slots = PackedStringArray()
	for i in range(value):
		slots.push_back("empty")
	if current_domino.initial_connected_side == 1:
		current_domino.setup(Domino.SideSettings.new(slots), null)
	else:
		current_domino.setup(null, Domino.SideSettings.new(slots))



func _on_add_random_symbol_button_pressed() -> void:
	symbol_pool.shuffle()
	
	var side = get_current_side()
	if not current_domino.has_empty_slot(side):
		while symbol_pool[0] in current_domino.ab_types[side]:
			symbol_pool.shuffle()
		
	current_domino.push_symbol(side, symbol_pool[0])


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
	var side := get_current_side()
	if colors.size() > 1:
		while colors[0] == (current_domino.a_color if side == 0 else current_domino.b_color): 
			colors.shuffle()
	if side == 0:
		current_domino.a_color = colors[0]
	else:
		current_domino.b_color = colors[0]


func _on_reroll_button_pressed() -> void:
	assert(current_domino != null)
	var value = 0
	if current_domino.initial_connected_side == 1:
		while value == 0 or current_domino.a == value:
			value = 1 + randi() % 4
		current_domino.setup(Domino.SideSettings.new([current_domino.a_type]))
	else:
		while value == 0 or current_domino.b == value:
			value = 1 + randi() % 4
		current_domino.setup(null, Domino.SideSettings.new([current_domino.b_type]))


func _on_domino_added_to_board(domino) -> void:
	reroll_button.disabled = false
	change_number_button.disabled = false
	add_random_symbol_button.disabled = false
	remove_random_symbol_button.disabled = false
	change_color_button.disabled = false
	current_domino = domino


func _on_domino_chain_removed() -> void:
	reroll_button.disabled = true
	change_number_button.disabled = true
	add_random_symbol_button.disabled = true
	remove_random_symbol_button.disabled = true
	change_color_button.disabled = true
	current_domino = null
