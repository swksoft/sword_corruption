extends ProgressBar

@onready var player = $".." as Player

func _ready():
	max_value = player.max_charge_time
	value = player.charge_time
	EVENTS.charge_bar_up.connect(on_charge_bar_up)

func on_charge_bar_up(amount):
	value = amount
