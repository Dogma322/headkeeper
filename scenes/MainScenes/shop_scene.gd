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
	if not slot.selected.is_connected(selected):
		slot.selected.connect(selected.bind(slot))
	slot.show()
	slot.update(Run.gold)


func fill(type: ShopSlot.ItemType, slots: Array[ShopSlot], source: Dictionary, allowed, selected: Callable) -> void:
	var pool = []
	for key in source.keys():
		if allowed != null:
			if key not in allowed.keys():
				continue
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


func buy(slot: ShopSlot) -> bool:
	if money_tween and money_tween.is_running():
		return false
	if slot.try_buy(Run.gold):
		money_tween = create_tween()
		money_tween.tween_property(Run, "gold", Run.gold - slot.item_cost, 0.25)
		get_tree().call_group("ShopSlots", "update", Run.gold - slot.item_cost)
		return true
	return false


func head_selected(slot: ShopSlot) -> void:
	if buy(slot):
		var head: Head = HeadManager.head_pool[slot.item_key].instantiate()
		head.key = slot.item_key
		Run.current_head_pool.push_back(head)
		Run.current_head_pool_keys.push_back(slot.item_key)
		Run.reserved_head_pool.erase(slot.item_key)
		
		head.add_head_to_head_holder()


func bonus_selected(slot: ShopSlot) -> void:
	if buy(slot):
		Run.current_bonus_pool.erase(slot.item_key)
		
		var bonus: BonusTemplate = BonusManager.bonus_templates[slot.item_key]
		var bonus_fx = BonusManager.bonus_effects[bonus.tag]
		if not BoardManager.bonus_pool.has(bonus_fx):
			BoardManager.bonus_pool.append(bonus_fx)
			Signals.bonus_amount_changed.emit()


func domino_selected(slot: ShopSlot) -> void:
	if buy(slot):
		slot.domino.add_domino_to_deck()
		slot.domino.get_parent().remove_child(slot.domino)
		slot.domino = null


func show_remove_domino_scene(slot: ShopSlot) -> void:
	if buy(slot):
		SceneManager.main_scene = SceneManager.remove_domino_scene
		SceneManager.show_remove_domino_scene(1)
		await Signals.action_card_selected
		await Transition.blackout()
		
		SceneManager.main_scene = SceneManager.shop_scene
		SceneManager.show_shop_scene()


func refill() -> void:
	setup_slot(remove_domino_slot, ShopSlot.ItemType.REMOVE_DOMINO, "remove_domino", 75, show_remove_domino_scene)
	fill(ShopSlot.ItemType.HEAD, head_slots, HeadManager.head_templates, Run.reserved_head_pool, head_selected)
	fill(ShopSlot.ItemType.BONUS, bonus_slots, BonusManager.bonus_templates, Run.current_bonus_pool, bonus_selected)
	fill(ShopSlot.ItemType.DOMINO, domino_slots, DominoManager.domino_templates, null, domino_selected)


func start() -> void:
	Foreground.options_panel.show_box(Foreground.options_panel.shop_box)
	SceneManager.background.set_shop_background()


func end() -> void:
	SceneManager.background.set_map_background()


func _on_play_button_pressed() -> void:
	await Transition.blackout()
	SceneManager.main_scene = SceneManager.map_scene
	SceneManager.show_map_scene()
