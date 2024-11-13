class_name Enemy extends CharacterBody2D

@export var health_component : HealthComponent
@export var hurtbox_component : HurtboxComponent
@export var bullet_scene : PackedScene

enum State { IDLE, MOVING, SHOOTING }

var affected_by_gravity := true
var gravity := 980
var speed := 50
var current_state := State.IDLE
var direction := -1

func _ready():
	change_state(State.MOVING)

func change_state(new_state: State):
	current_state = new_state
	match new_state:
		State.IDLE:
			velocity = Vector2.ZERO
		State.MOVING:
			velocity.x = speed * direction
		State.SHOOTING:
			shoot()

func _physics_process(delta):
	if affected_by_gravity:
		velocity.y += gravity * delta  # Aplica gravedad

	match current_state:
		State.MOVING:
			move_and_check_collision(delta)
		State.SHOOTING:
			pass

	move_and_slide()

func move_and_check_collision(delta):
	if is_on_edge_or_collision():
		direction *= -1
		velocity.x = speed * direction

func is_on_edge_or_collision() -> bool:
	return !is_on_floor() || get_slide_collision_count() > 0

func shoot():
	pass

func _on_health_component_die():
	POINTS.emit_add_points(50)
	queue_free()
