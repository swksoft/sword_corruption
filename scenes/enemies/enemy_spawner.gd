extends Area2D
class_name EnemySpawner

@export var enemy_spawn : PackedScene
@export var min_spawn_time := 1.0     # Tiempo mínimo de spawn
@export var max_spawn_time := 3.0     # Tiempo máximo de spawn
@export var invert_direction : bool = false

func _ready():
	randomize()
	start_spawning()

func _on_timer_timeout():
	spawn_enemy()

# START
func start_spawning():
	if not $Timer.is_stopped():
		$Timer.stop()  # Asegura que esté detenido antes de reiniciarlo
	$Timer.wait_time = randf_range(min_spawn_time, max_spawn_time)
	$Timer.start()

# STOP
func stop_spawning():
	$Timer.stop()

# SPAWN
func spawn_enemy():
	if enemy_spawn:
		var enemy_instance = enemy_spawn.instantiate()
		enemy_instance.position = position
		if invert_direction == true:
			enemy_instance.direction = Vector2.LEFT
		else:
			enemy_instance.direction = Vector2.RIGHT
		
		var random_x = randi_range(position.x - (global_position.x / 2), position.x + (global_position.x / 2))
		var random_y = randi_range(position.y - (global_position.y / 2), position.y + (global_position.y / 2))
		enemy_instance.global_position = Vector2(random_x, random_y)
			
		get_parent().add_child(enemy_instance)


