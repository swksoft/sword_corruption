extends MapEntity

func _ready():
	init_entity("ExitDoor", false, true, 2500, "res://Music/sfx/Powerup.ogg")

func on_interact():
	print(sfx)
	if sfx != "" and sfx != null:
		BGM.play_sound(sfx)
		
	print("Finished Level!")
	
	POINTS.emit_add_points(value)
	
