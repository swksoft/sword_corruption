extends ProgressBar

func _ready():
	value = 0
	max_value = 10
	EVENTS.corruption_bar_up.connect(on_corruption_bar_up)

func on_corruption_bar_up(amount: float):
	value += amount
