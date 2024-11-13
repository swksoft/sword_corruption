class_name Player extends CharacterBody2D

# Managers & Components
@export var animation_manager : AnimationManager
@export var health_component : HealthComponent
@export var corruption_manager : CorruptionManager
@export var tile_map : TileMap

# TODO: Saltar te hace rapido

var is_knockback_active := false
var can_attack_midair := false
var input_anabled := true

# Movement Variables
@export var speed := 200.0
@export var air_acceleration := 15.0
@export var ground_acceleration := 25.0
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
	
	if Input.is_action_pressed("left") and input_anabled:
		target_direction -= 1.0
	if Input.is_action_pressed("right") and input_anabled:
		target_direction += 1.0

	# ACELERACION EN EL AIRE
	var acceleration := ground_acceleration if is_on_floor() else air_acceleration

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

	# MIDAIR ATTACK	
	if !is_on_floor() and can_attack_midair == true and Input.is_action_just_pressed("attack"):
		execute_attack(0)
	
	#$CantAttack.visible = Input.is_action_pressed("attack") and !can_attack

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
	
func execute_attack(charge_level = 0):
	$Sword.damage = 1
	
	if charge_level == 0 and !is_on_floor():
		$Sword.damage = 1
		animation_manager.animation_node = $Sword/AnimationPlayer
		animation_manager.attack_animation(charge_level)
		return
	
	charge_level = min(charge_time / max_charge_time, 1.0)
	charge_level = clamp(charge_level, 0.0, 1.0)
	is_charging = false
	can_attack = false
	
	$ChargeBar.visible = false
	
	#EVENTS.emit_corruption_bar_up(charge_level)
	print(charge_level)
	corruption_manager.get_corruption(charge_level)
	
	var base_damage = $Sword.damage
	var exponent = 2
	var scale_factor = 5
	var operation = base_damage + pow(charge_level * scale_factor, exponent)
	
	$Sword.damage = operation
	
	animation_manager.animation_node = $Sword/AnimationPlayer
	animation_manager.attack_animation(charge_level)
	
	print($Sword.damage)
	

func _on_sword_jump():
	var charge_level = min(charge_time / max_charge_time, 1.0)
	
	if charge_level != 1:
		charge_level = clamp(charge_level, 0.0, 1.0)
		velocity.y = jump_velocity * (charge_time / max_charge_time) * 1.5
		can_attack_midair = true
		

func _on_sword_recovered():
	can_attack = true

func _on_health_component_die():
	visible = false
	EVENTS.emit_freeze_game()
	
