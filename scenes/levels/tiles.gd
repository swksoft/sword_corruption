extends TileMap

const BACKGROUND_STATES_TEXTURES = [
	"res://assets/tileset-packed16.png",
	"res://assets/tileset-trash16.png"
]

var background_state = 0

func _ready():
	EVENTS.freeze_game.connect(_on_freeze_game)
	EVENTS.corrupt_area.connect(on_corrupt_area)
	
	background_state = 0 #= (background_state + 1) % 2 # After 2 comes 0 again	
	var texture = load(BACKGROUND_STATES_TEXTURES[background_state])
	tile_set.get_source(0).texture = texture

func _on_freeze_game():
	background_state = 1 # (background_state + 1) % 2 # After 2 comes 0 again	
	var texture = load(BACKGROUND_STATES_TEXTURES[background_state])
	tile_set.get_source(0).texture = texture
	global_position += Vector2(10,6)

func on_corrupt_area(coords : Vector2i, large_area):
	if large_area:
		var random_tile_x = randi() % 15
		var random_tile_y = randi() % 15
		set_cell(1, coords, 1, Vector2i(random_tile_x, random_tile_y))
	else:
		var surrounding_cells = get_surrounding_cells(coords)
		var near_solid_cells = get_used_cells(1)
		
		for cell in surrounding_cells:
			if get_cell_source_id(1, cell) == 2:
				print("ABORTAR ABORTAR")
				return
			
			var random_tile_x = randi() % 15
			var random_tile_y = randi() % 15
			var random_texture = randi() % 2
			set_cell(1, Vector2i(random_tile_x, random_tile_y), random_texture, Vector2i(random_tile_x, random_tile_y))
			
		if randf() < 0.9:#0.1:
			var random_tile_x = randi() % 15
			var random_tile_y = randi() % 15
			var random_texture = randi() % 2
			
			if near_solid_cells == []:
				return
			
			set_cell(1, near_solid_cells.pick_random(), random_texture, Vector2i(random_tile_x, random_tile_y))
