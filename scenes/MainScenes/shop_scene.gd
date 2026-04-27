@tool
extends ScreenBase
class_name ShopScene

@onready var head_slots: Array[ShopSlot] = [%HeadSlot, %HeadSlot2, %HeadSlot3]
@onready var bonus_slots: Array[ShopSlot] = [%BonusSlot, %BonusSlot2, %BonusSlot3]
@onready var domino_slots: Array[ShopSlot] = [%DominoSlot, %DominoSlot2, %DominoSlot3, %DominoSlot4, %DominoSlot5]
@onready var remove_domino_slot: ShopSlot = %RemoveDominoSlot
@onready var tooltip_panel: TooltipPanel = %TooltipPanel

var money_tween: Tween

func setup_slot(slot: ShopSlot, type, key, cost, selected: Callable) -> void:
	slot.screen = self
	slot.item_type = type
	slot.item_key = key
	slot.item_cost = cost
	slot.selected.connect(selected.bind(slot))
	

func fill(type: ShopSlot.ItemType, slots: Array[ShopSlot], source: Dictionary, selected: Callable) -> void:
	var pool = []
	for key in source:
		pool.push_back(key)
	pool.shuffle()
	
	var i = 0
	for slot: ShopSlot in slots:
		slot.screen = self
		var item = null
		if i < pool.size():
			item = source[pool[i]]
		if item != null:
			setup_slot(slot, type, pool[i], item.gold_cost, selected)
		i += 1


func _ready() -> void:
	setup_slot(remove_domino_slot, ShopSlot.ItemType.REMOVE_DOMINO, "", 75, show_remove_domino_scene)


func buy(slot: ShopSlot) -> void:
	if money_tween and money_tween.is_running():
		return
	if slot.try_buy(MoneyManager.gold):
		money_tween = create_tween()
		money_tween.tween_property(MoneyManager, "gold", MoneyManager.gold - slot.item_cost, 0.25)
		await money_tween.finished
		


func head_selected(slot: ShopSlot) -> void:
	buy(slot)


func bonus_selected(slot: ShopSlot) -> void:
	buy(slot)


func domino_selected(slot: ShopSlot) -> void:
	buy(slot)


func show_remove_domino_scene(slot: ShopSlot) -> void:
	buy(slot)


func refill() -> void:
	fill(ShopSlot.ItemType.HEAD, head_slots, HeadManager.head_templates, head_selected)
	fill(ShopSlot.ItemType.BONUS, bonus_slots, BonusManager.bonus_templates, bonus_selected)
	fill(ShopSlot.ItemType.DOMINO, domino_slots, DominoManager.domino_templates, domino_selected)


func start() -> void:
	Foreground.options_panel.show_box(Foreground.options_panel.shop_box)
	SceneManager.background.set_shop_background()


func end() -> void:
	SceneManager.background.set_map_background()


func _on_play_button_pressed() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1.0).timeout
	Transition.blackout_off()
	
	SceneManager.show_map_scene()
