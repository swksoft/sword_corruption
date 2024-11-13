class_name BasicEnemy extends CharacterBody2D

@export var health_component : HealthComponent
@export var hurtbox_component : HurtboxComponent
@export var bullet_scene : PackedScene
@export var randomized : bool
@export var direction := Vector2.LEFT
@export var can_shoot := false
@export var affected_by_gravity := true
@export var shoot_interval := 5.0
@export var can_turn_around := false
@export var turn_time := 5.0
@export var points := 50

var gravity := 190
@export var speed := 100
var on_damage := false
var sine_time := 0.0 
@export var amplitude := 30.0
@export var period := 2.0

func _ready():
	if randomized:
		randomized
		direction.x = randi_range(0,1)
		if direction.x == 0:
			direction.x = -1
	if can_shoot:
		$ShootTimer.wait_time = shoot_interval
		$ShootTimer.start()
	if can_turn_around:
		$TurnTimer.wait_time = turn_time
		$TurnTimer.start()

func _physics_process(delta):
	if affected_by_gravity:
		if not is_on_floor():
			velocity.y += gravity * delta
		if is_on_floor():
			velocity = direction * speed
	else:
		sine_time += delta
		velocity.x = direction.x * speed
		velocity.y = amplitude * sin(sine_time * TAU / period)
	
	$Sprite.flip_h = direction.x < 0
	if on_damage == true:
		velocity.x = 0

	move_and_slide()

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = self.position

func _on_health_component_die():
	POINTS.emit_add_points(points)
	queue_free()

func _on_shoot_timer_timeout():
	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = global_position
		var bullet_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
		bullet.direction = bullet_dir
		#var acceleration := ground_acceleration if is_on_floor() else air_acceleration
		get_tree().current_scene.add_child(bullet)

func _on_turn_timer_timeout():
	direction *= -1
	velocity.x = direction.x * speed
