extends MapEntity

func _ready():
	init_entity("Coin", true, false, 25, "res://Music/sfx/Pause.ogg")
	
	randomize()
	
	if randi_range(0,1) == 0:
		$Sprite.region_rect = Rect2(128, 176, 16, 16)
	else:
		$Sprite.region_rect = Rect2(144, 176, 16, 16)

func on_interact():
	print(sfx)
	if sfx != "" and sfx != null:
		BGM.play_sound(sfx)
		
	print("Coin Get!")
	
	POINTS.emit_add_points(value)
	
	self.queue_free()
