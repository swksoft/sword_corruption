class_name Player extends CharacterBody2D

# Managers
@export var animation_manager : AnimationManager

# TODO: EL PERSONAJE DEBE PODER APLASTAR ENEMIGOS COMO MARIO

# Movement Variables
@export var speed := 200.0
@export var air_acceleration := 15.0  # Aceleración limitada en el aire
@export var ground_acceleration := 25.0  # Aceleración en el suelo
@export var gravity := 500.0
@export var jump_velocity := -300.0

var velocity_x := 0.0

# Attack Variables
@export var max_charge_time := 1.0
var is_charging := false
var charge_time := 0.0

func _ready():
	animation_manager.animation_node = $Sword/AnimationPlayer
	animation_manager.play_animation("idle")

func _physics_process(delta: float) -> void:
	var target_direction := 0.0
	
	if Input.is_action_pressed("left"):
		target_direction -= 1.0
	if Input.is_action_pressed("right"):
		target_direction += 1.0
	if Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()

	# ACELERACION EN EL AIRE
	var acceleration := ground_acceleration if is_on_floor() else air_acceleration

	# Ajuste gradual de la velocidad en la dirección del objetivo
	if target_direction != 0.0:
		if sign(velocity_x) == sign(target_direction) or is_on_floor():
			velocity_x = lerp(velocity_x, target_direction * speed, acceleration * delta)
	else:
		velocity_x = lerp(velocity_x, 0.0, acceleration * delta)

	velocity.x = velocity_x

	# CARGA
	if is_on_floor() and Input.is_action_just_pressed("attack"):
		is_charging = true
		charge_time = 0.0
		$ChargeBar.visible = true

	if is_charging:
		charge_time += delta
		EVENTS.emit_charge_bar_up(charge_time)
		if Input.is_action_just_released("attack") or charge_time >= max_charge_time:
			execute_attack()

	# GRAVITY
	if not is_on_floor():
		velocity.y += gravity * delta

	# MISC
	if target_direction != 0.0:
		$Sprite.flip_h = velocity_x < 0
		$Sword.position.x = -8 if velocity_x < 0 else 8
		$Sword.scale.x = 1 if velocity_x >= 0 else -1 
		
	move_and_slide()
	
func execute_attack() -> void:
	var charge_level = min(charge_time / max_charge_time, 1.0)
	charge_level = clamp(charge_level, 0.0, 1.0)
	print("Charge Time: ", charge_level)
	velocity.y = jump_velocity * (charge_time / max_charge_time)
	is_charging = false
	$ChargeBar.visible = false
	EVENTS.emit_corruption_bar_up(charge_level)
	
	animation_manager.attack_animation(charge_level)

