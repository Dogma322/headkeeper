extends Node2D

@export var domino_scene = preload("res://scenes/Dominoes/DominoTemplate/domino_template.tscn")

@export var hand_height := 320
@export var hand_width = 320
@export var spacing := 36
@export var curve := 0
@export var fan_rotation := 0

var dominoes:Array[Domino] = []



func _ready():


	position.y = hand_height
	#draw_dominoes()
	#adding_dm()
		
func adding_dm():
	for i in range(5):
		add_domino(domino_scene.instantiate())

func move_to_hand(domino, pos:Vector2):

	domino.returning_to_hand = true
	domino.reset_rotation()

	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(
		domino,
		"global_position",
		global_position + pos,
		0.3
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(
		domino,
		"scale",
		Vector2(1,1),
		0.3
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	await tween.finished

	domino.returning_to_hand = false




func add_domino(domino:Domino):

	domino.slot = null
	domino.connected_side = 1 
	
	if domino not in dominoes:
		dominoes.append(domino)


	if domino.get_parent():
		domino.get_parent().remove_child(domino)

		
	var root = get_tree().get_current_scene()
	root.add_child(domino)

	update_layout()



func remove_domino(domino:Domino):

	dominoes.erase(domino)

	update_layout()



func update_layout():

	var count = dominoes.size()

	if count == 0:
		return

	for i in range(count):

		var domino = dominoes[i]

		var center = (count - 1) / 2.0
		var offset = i - center

		var x = offset * spacing + hand_width

		var t = float(i) / (count - 1) if count > 1 else 0.5
		var y = -sin(t * PI) * curve

		var pos = Vector2(x, y)

		domino.rotation_degrees = offset * fan_rotation

		#domino.move_to_hand(pos)
		move_to_hand(domino, pos)

		
		
		
		
		
		
func draw_dominoes():

	await get_tree().create_timer(0.2).timeout
	
	var draw_count = DominoManager.draw_counter + DominoManager.bonus_draw_counter
	DominoManager.bonus_draw_counter = 0
		
	for i in range(draw_count):
		
		if DominoManager.temp_deck.size() == 0 and DominoManager.discard.size() == 0:
			return
		
		if DominoManager.temp_deck.size() <= 0:
			DominoManager.reshuffle_discard_into_deck()


		var domino = DominoManager.temp_deck.pick_random()
		

		
		DominoManager.temp_deck.erase(domino)
		
		
		# Если кость уже где-то, убираем
		if domino.get_parent():
			domino.get_parent().remove_child(domino)
			#await get_tree().process_frame
			
		draw_domino(domino)
		await get_tree().create_timer(0.1).timeout
		
	print("SIZE")
	print(">>> draw_dominoes called <<<")
	print(dominoes.size())

		
func draw_domino(domino):
	
	domino.scale = Vector2(0.2, 0.2)
	domino.global_position = Vector2(15,300)
	
	
	DominoManager.temp_deck.erase(domino)   

	add_domino(domino)


func discard_all_dominoes():
	# Собираем все домино из руки и из played_domino
	var all_dominoes := []
	all_dominoes.append_array(dominoes)
	all_dominoes.append_array(DominoManager.dominoes_on_board)
	

	for domino in all_dominoes:
		domino.reset_rotation()
		if domino.slot:
			domino.slot.remove_domino()
		
		if !is_instance_valid(domino):
			continue

		# Случайный сдвиг по X
		var random_offset_x := randf_range(-100, 100)
		# Куда падает (ниже экрана)
		var target_y := get_viewport_rect().size.y + 200
		var target_position := Vector2(domino.position.x + random_offset_x, target_y)

		# Случайная длительность падения
		var duration := randf_range(0.5, 1.0)

		var tween := get_tree().create_tween()
		tween.tween_property(domino, "position", target_position, duration)\
			.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)

		# Немного вращения для красоты
		var random_rotation := randf_range(-2*PI, 2*PI)
		tween.parallel().tween_property(domino, "rotation", random_rotation, duration)

		# После падения — переносим в сброс
		tween.finished.connect(func():
			if is_instance_valid(domino):
				if domino.get_parent():
					domino.get_parent().remove_child(domino)
					
				else:
					DominoManager.discard.append(domino)
					
		)
		DominoManager.discard.append(domino)

	
	# очищаем списки
	dominoes.clear()
	DominoManager.dominoes_on_board.clear()
	
	
	
	
	
	
	
	
#func draw_dominoes2(number_of_dominoes:int):
#
	#if DominoManager.temp_deck.size() == 0 and DominoManager.discard.size() == 0:
		#return
		#
#
#
	#for i in range(number_of_dominoes):
		#
#
		#if DominoManager.temp_deck.size() <= 0:
			#DominoManager.reshuffle_discard_into_deck()
#
		#var domino = DominoManager.temp_deck.pick_random()
#
		#if domino.get_parent():
			#domino.get_parent().remove_child(domino)
#
		#domino.scale = Vector2(0.2,0.2)
		#domino.global_position = Vector2(15,320)
#
		#DominoManager.temp_deck.erase(domino)
#
		#add_domino(domino)
		##dominoes.append(domino)
		##add_child(domino)
#
		#update_hand_positions()
#
		#await get_tree().create_timer(0.1).timeout
		#
		#
#func update_hand_positions():
#
	#var total_dominoes := dominoes.size()
	#if total_dominoes == 0:
		#return
		#
		#
#
	#var _spacing := 36
	#var total_width := (total_dominoes - 1) * _spacing
	#var start_x := (get_viewport_rect().size.x / 2.0) + (total_width / 2.0)
#
	#for i in range(total_dominoes):
		#var domino = dominoes[i]
#
		#if domino.dragging:
			#continue
		## НЕ трогаем те, что на поле / играются
#
		## Блокируем кость на время анимации
#
		#var target_x := start_x - i * spacing
		#var target_position := Vector2(target_x, 300)
#
		#var tween := get_tree().create_tween()
		#tween.set_parallel()
		#tween.tween_property(domino, "scale", Vector2(1,1), 0.25)
		#tween.tween_property(domino, "global_position", target_position, 0.25)
		#
		#print(target_position)
#
		## Разблокируем после окончания анимации
