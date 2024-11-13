extends MapEntity

@export var end_screen = Node

func _ready():
	init_entity("ExitDoor", false, true, 2500, "res://Music/sfx/Powerup.ogg")

func on_interact():
	if sfx != "" and sfx != null:
		BGM.play_sound(sfx)
	
	POINTS.emit_add_points(value)
	
	EVENTS.emit_end_level()
	
