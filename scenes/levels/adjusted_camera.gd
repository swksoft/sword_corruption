extends Camera2D

@export var player : Player

func _process(delta):
	if !player:
		return
	
	position = player.global_position
