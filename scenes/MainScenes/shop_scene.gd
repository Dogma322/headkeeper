@tool
extends ScreenBase
class_name ShopScene

@onready var head_slots := [%HeadSlot, %HeadSlot2, %HeadSlot3]
@onready var bonus_slots := [%BonusSlot, %BonusSlot2, %BonusSlot3]
@onready var domino_slots := [%DominoSlot, %DominoSlot2, %DominoSlot3, %DominoSlot4, %DominoSlot5]
@onready var remove_domino_slot = %RemoveDominoSlot

func fill_heads():
	var head_pool = []
	for key in HeadManager.head_templates:
		head_pool.push_back(key)
	head_pool.shuffle()
	
	var i = 0
	for head_slot: ShopSlot in head_slots:
		var head: HeadTemplate = null
		if i < head_pool.size():
			head = HeadManager.head_templates[head_pool[i]]
		if head != null:
			head_slot.item_key = head_pool[i]
			head_slot.item_cost = head.gold_cost
		i += 1

func fill_bonuses() -> void:
	pass

func start() -> void:
	SceneManager.background.set_shop_background()
	fill_heads()
	
	


func end() -> void:
	SceneManager.background.set_map_background()
