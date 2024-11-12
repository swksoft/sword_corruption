extends Node2D

const BACKGROUND_STATES_TEXTURES = [
	"res://assets/tileset-packed16.png",
	"res://assets/tileset-trash16.png"
]

var background_state = 0

func corrupt_everything():
	background_state = (background_state + 1) % 2 # After 2 comes 0 again	
	var texture = load(BACKGROUND_STATES_TEXTURES[background_state])
	$TileMap.tile_set.get_source(0).texture = texture
	
	#EVENTS.emit_corrupt_area()
	

func _process(delta):
	if Input.is_action_pressed("reset"):
		get_tree().reload_current_scene() # FIXME: CORREGIR
		
