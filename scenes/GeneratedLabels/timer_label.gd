extends Label

var start_time := 0

func _ready():
	reset_timer()

func _process(_delta):
	var ms_elapsed = Time.get_ticks_msec() - start_time
	var total_seconds = ms_elapsed / 1000

	var hours = total_seconds / 3600
	var minutes = (total_seconds % 3600) / 60
	var seconds = total_seconds % 60

	text = "%02d:%02d:%02d" % [hours, minutes, seconds]


func reset_timer():
	start_time = Time.get_ticks_msec()
