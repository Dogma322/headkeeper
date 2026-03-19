extends TextureButton

@onready var label = $Label

func _ready() -> void:
	label.text = "Рандомные поля: вкл"



func _on_mouse_entered() -> void:
	modulate = Color(1.3,1.3,1.3)
		


func _on_mouse_exited() -> void:
	modulate = Color(1,1,1)


func _on_pressed() -> void:
	if BoardManager.random_boards == true:
		BoardManager.random_boards = false
		BoardManager.reset_run()
		print("RANDOMBOARDS")
		label.text = "Рандомные поля: выкл"
	else:
		BoardManager.random_boards = true
		label.text = "Рандомные поля: вкл"
		BoardManager.reset_run()
