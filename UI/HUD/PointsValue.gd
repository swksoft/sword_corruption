extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	POINTS.total_points = 0
	text = str(zeros(POINTS.total_points))
	
	POINTS.add_points.connect(on_add_points)
	EVENTS.corrupt_area.connect(on_corruption)

func zeros(number):
	var score_text = str(POINTS.total_points)
	var total_length = 12
	
	while score_text.length() < total_length:
		score_text = "0" + score_text
	
	return score_text

func on_add_points(amount):
	POINTS.total_points += amount
	text = str(zeros(POINTS.total_points))

func on_corruption():
	randomize()
	var corrupted_text := ""
	var total_length = 12
	
	var allowed_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	
	for i in range(total_length):
		var random_char = allowed_chars[randi_range(0, allowed_chars.length() - 1)]
		corrupted_text += random_char
	
	text = corrupted_text
