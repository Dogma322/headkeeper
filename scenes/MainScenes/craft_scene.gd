extends Control

@onready var money_label: RichTextLabel = %MoneyLabel
@onready var exit_button: TextureButton = %ExitButton
@onready var accept_button: GameButton = %AcceptButton
@onready var reroll_button: GameButton = %RerollButton
@onready var cost_label: RichTextLabel = %CostLabel
@onready var board_craft: Board = $BoardCraft

var current_domino: Domino = null

func _ready() -> void:
	Transition.blackout_off()
	money_label.text = "[img]res://assets/Icons/CommonSkull.png[/img]%s" % [str(MetaManager.money)]
	Hand.draw_dominoes()
	accept_button.disabled = true
	reroll_button.disabled = true
	Signals.domino_added_to_board.connect(_on_domino_added_to_board)
	Signals.domino_chain_removed.connect(_on_domino_chain_removed)


func _on_exit_button_pressed() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1).timeout
	DominoManager.reset()
	get_tree().change_scene_to_file("res://scenes/MainScenes/main_menu.tscn")


func _on_accept_button_pressed() -> void:
	pass # Replace with function body.


func _on_reroll_button_pressed() -> void:
	assert(current_domino != null)
	var value = 0
	if current_domino.initial_connected_side == 1:
		while value == 0 or current_domino.a == value:
			value = 1 + randi() % 4
		current_domino.setup(Domino.SideSettings.new(value, current_domino.a_type))
	else:
		while value == 0 or current_domino.b == value:
			value = 1 + randi() % 4
		current_domino.setup(null, Domino.SideSettings.new(value, current_domino.b_type))


func _on_domino_added_to_board(domino) -> void:
	reroll_button.disabled = false
	current_domino = domino


func _on_domino_chain_removed() -> void:
	reroll_button.disabled = true
	current_domino = null
