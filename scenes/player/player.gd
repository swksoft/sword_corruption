class_name Player extends CharacterBody2D

# Managers & Components
@export var animation_manager : AnimationManager
@export var health_component : HealthComponent

# TODO: EL PERSONAJE DEBE PODER APLASTAR ENEMIGOS COMO MARIO (bros)

var is_knockback_active := false

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
var can_attack := true
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
	if is_on_floor() and Input.is_action_just_pressed("attack") and can_attack:
		is_charging = true
		charge_time = 0.0
		$ChargeBar.visible = true
	
	$CantAttack.visible = Input.is_action_pressed("attack") and !can_attack

	if is_charging:
		charge_time += delta
		EVENTS.emit_charge_bar_up(charge_time)
		if Input.is_action_just_released("attack") or charge_time >= max_charge_time:
			execute_attack()

	# GRAVITY
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# MISC
	if is_on_floor():
		if $AnimationPlayer.current_animation == "jump":
			$AnimationPlayer.play("RESET")  # Cambia a una animación específica o detén la animación
	else:
		if $AnimationPlayer.current_animation != "jump":
			$AnimationPlayer.play("jump")
	
	if target_direction != 0.0:
		$Sprite.flip_h = velocity_x < 0
		$Sword.position.x = -8 if velocity_x < 0 else 8
		$Sword.scale.x = 1 if velocity_x >= 0 else -1
		
	move_and_slide()
	
func execute_attack():
	var charge_level = min(charge_time / max_charge_time, 1.0)
	charge_level = clamp(charge_level, 0.0, 1.0)
	is_charging = false
	can_attack = false
	$ChargeBar.visible = false
	
	EVENTS.emit_corruption_bar_up(charge_level)
	
	var base_damage = $Sword.damage
	var exponent = 2
	var scale_factor = 5
	var operation = base_damage + pow(charge_level * scale_factor, exponent)
	
	$Sword.damage = operation
	
	animation_manager.animation_node = $Sword/AnimationPlayer
	animation_manager.attack_animation(charge_level)

func _on_sword_jump():
	var charge_level = min(charge_time / max_charge_time, 1.0)
	
	if charge_level != 1:
		charge_level = clamp(charge_level, 0.0, 1.0)
		velocity.y = jump_velocity * (charge_time / max_charge_time) * 1.5

func _on_sword_recovered():
	can_attack = true

func _on_health_component_die():
	queue_free()
