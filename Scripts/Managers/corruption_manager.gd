extends Node
class_name CorruptionManager

@export var tile_map_original: TileMap
@export var tile_map_overlay: TileMap

@export var corruption_25_percent_scene : PackedScene
@export var corruption_50_percent_scene : PackedScene
@export var corruption_75_percent_scene : PackedScene

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

func corrupt_area_haha():
	if has_node("../TileMapT") and has_node("../TileMap"):
		# Borrar todos los tiles en $TileMap antes de copiar
		for cell_pos in $"../TileMap".get_used_cells(1):
			$"../TileMap".erase_cell(1, cell_pos)
		
		# Obtener todas las posiciones usadas y las coordenadas del atlas de $TileMapC
		var used_cells = $"../TileMapT".get_used_cells(1)
		var tiles_data = []
		
		for cell_pos in used_cells:
			# Obtener ID y coordenadas del atlas de cada tile en $TileMapC
			var atlas_coords = $"../TileMapT".get_cell_atlas_coords(1, cell_pos)
			var tile_id = $"../TileMapT".get_cell_source_id(1, cell_pos)
			tiles_data.append({
				"position": cell_pos,
				"tile_id": tile_id,
				"atlas_coords": atlas_coords
			})
		
		# Colocar los tiles en $TileMap usando la información recopilada de $TileMapC
		for tile_info in tiles_data:
			$"../TileMap".set_cell(0, tile_info["position"], tile_info["tile_id"], tile_info["atlas_coords"])

func on_corruption_25():
	if corruption_75_percent_scene != null:
		pass
	#corrupt_area_haha()
		
		#$"../TileMapT".set_layer_enabled(3, true)
		
		#var copy_pos = $"../TileMapT".get_used_cells(1)
		#var copy_atlas = $"../TileMapT".get_cell_atlas_coords(1)
		#var original_pos = $"../TileMap".get_used_cells(1)
		#var original_atlas = $"../TileMap".get_cell_atlas_coords(1)
		#for cell in original_pos:
			#$"../TileMap".erase_cell(1, cell)#(1, cell, 0, atlas)
		#
		#$"../TileMapT".set_layer_enabled(1, true)
			#
		#for cell in copy_pos:
			#for atlas in copy_atlas:
				#$"../TileMap".set_cell(1, cell, 0, atlas)
	EVENTS.emit_corrupt_time(1)

func on_corruption_50():
	if corruption_50_percent_scene != null:
		pass
	corrupt_area_haha()
	$"../TileMapT".set_layer_enabled(2, true)
	
	#if has_node("../TileMapT"):
		#$"../TileMapT".set_layer_enabled(4, true)
	EVENTS.emit_corrupt_time(2)

func on_corruption_75():
	if corruption_75_percent_scene != null:
		pass
	#if has_node("../TileMapT"):
		#$"../TileMapT".set_layer_enabled(5, true)
	EVENTS.emit_corrupt_time(3)

func on_corruption_full():
	# CRASHEO
	EVENTS.emit_freeze_game()
	print("Corruption has reached 100%")

func on_freeze_game():
	end_screen.show_message(false)
