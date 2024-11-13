extends Node
class_name CorruptionManager

@export var end_screen : Node

@export var corruption_max_value : float = 10
var corruption_amount : float = 0

func _ready():
	EVENTS.freeze_game.connect(on_freeze_game)

func get_corruption(amount: float):
	print_debug(amount)
	corruption_amount += amount
	
	var percentage = corruption_amount / corruption_max_value * 100

	if corruption_amount >= corruption_max_value:
		on_corruption_full()
		
	if percentage >= 75:
		on_corruption_75()
	elif percentage >= 50:
		on_corruption_50()
	elif percentage >= 25:
		on_corruption_25()
	
	EVENTS.emit_corruption_bar_up()

func on_corruption_25():
	if has_node("../TileMapT"):
		$"../TileMapT".set_layer_enabled(3, true)
	EVENTS.emit_corrupt_time(1)

func on_corruption_50():
	if has_node("../TileMapT"):
		$"../TileMapT".set_layer_enabled(4, true)
	EVENTS.emit_corrupt_time(2)

func on_corruption_75():
	if has_node("../TileMapT"):
		$"../TileMapT".set_layer_enabled(5, true)
	EVENTS.emit_corrupt_time(3)

func on_corruption_full():
	# CRASHEO
	EVENTS.emit_freeze_game()
	print("Corruption has reached 100%")

func on_freeze_game():
	end_screen.show_message(false)
