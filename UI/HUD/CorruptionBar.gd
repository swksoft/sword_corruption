extends ProgressBar

@export var corruption_manager : CorruptionManager

func _ready():
	max_value = corruption_manager.corruption_max_value
	value = corruption_manager.corruption_amount
	EVENTS.corruption_bar_up.connect(on_corruption_bar_up)
	EVENTS.hud_ready.connect(on_hud_ready)

func on_corruption_bar_up():
	value = corruption_manager.corruption_amount

func on_hud_ready():
	max_value = corruption_manager.corruption_max_value
	value = corruption_manager.corruption_amount
	
	print(corruption_manager.corruption_amount)
	print(corruption_manager.corruption_max_value)
