@tool
extends ScreenBase
class_name ShopScene

@onready var head_slots: Array[ShopSlot] = [%HeadSlot, %HeadSlot2, %HeadSlot3]
@onready var bonus_slots: Array[ShopSlot] = [%BonusSlot, %BonusSlot2, %BonusSlot3]
@onready var domino_slots: Array[ShopSlot] = [%DominoSlot, %DominoSlot2, %DominoSlot3, %DominoSlot4, %DominoSlot5]
@onready var remove_domino_slot: ShopSlot = %RemoveDominoSlot
@onready var tooltip_panel: TooltipPanel = %TooltipPanel


func fill(type: ShopSlot.ItemType, slots: Array[ShopSlot], source: Dictionary) -> void:
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
			slot.item_type = type
			slot.item_key = pool[i]
			slot.item_cost = item.gold_cost
		i += 1


func start() -> void:
	SceneManager.background.set_shop_background()
	
	remove_domino_slot.screen = self
	fill(ShopSlot.ItemType.HEAD, head_slots, HeadManager.head_templates)
	fill(ShopSlot.ItemType.BONUS, bonus_slots, BonusManager.bonus_templates)
	fill(ShopSlot.ItemType.DOMINO, domino_slots, DominoManager.domino_templates)


func end() -> void:
	SceneManager.background.set_map_background()


func _on_play_button_pressed() -> void:
	Transition.blackout_on()
	await get_tree().create_timer(1.0).timeout
	Transition.blackout_off()
	
	SceneManager.show_map_scene()
