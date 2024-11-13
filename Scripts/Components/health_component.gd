extends Node
class_name HealthComponent

signal die

@export var max_health: float = 5
@export var knockback_duration: float = 0.5

var velocity: Vector2 = Vector2.ZERO  
var current_health: float

var invulnerable: bool = false
var invulnerability_duration: float = 0.75  # Tiempo de invulnerabilidad en segundos
var invulnerability_timer: Timer

@onready var timer = $Timer

func _ready():
	current_health = max_health
	invulnerability_timer = Timer.new()
	invulnerability_timer.wait_time = invulnerability_duration
	invulnerability_timer.one_shot = true
	invulnerability_timer.timeout.connect(_on_invulnerability_timeout)
	add_child(invulnerability_timer)

func _on_hurtbox_component_hit_detected(damage):
	if invulnerable:
		return
		
	BGM.play_sound("res://Music/sfx/Hurt.ogg")
	
	current_health -= damage
	
	invulnerable = true
	invulnerability_timer.start()
	
	if has_node("../AnimationPlayer"):
		$"../AnimationPlayer".play("invulnerability")
	
	if current_health <= 0:
		die.emit()

	show_health()

func _physics_process(delta):
	if velocity.length() > 0:
		get_parent().position += (velocity + Vector2(0,-5)) * delta
		velocity = velocity.lerp(Vector2.ZERO, delta * 3)
		
		if get_parent() is Player:
			get_parent().input_anabled = false
		else:
			get_parent().on_damage = true

func _end_knockback(): # FIXME: a
	if get_parent() is Player:
		get_parent().input_anabled = true
	else:
		get_parent().on_damage = false
	get_parent().velocity = Vector2.ZERO
	set_physics_process(false)

func _on_invulnerability_timeout():
	invulnerable = false
	if has_node("../AnimationPlayer"):
		$"../AnimationPlayer".play("RESET")

func _on_hurtbox_player_knockback(knockback_vector):
	velocity = knockback_vector
	set_physics_process(true)  # Activa el proceso de física para aplicar knockback

	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = knockback_duration
	timer.timeout.connect(_end_knockback)
	add_child(timer)
	timer.start()

func show_health():
	var percentage = current_health / max_health * 100
	
	if percentage >= 100:
		get_parent().get_node("Sprite").modulate = Color.html("#ffd9d9")
	elif percentage >= 75:
		get_parent().get_node("Sprite").modulate = Color.html("#ffb3b3")
	elif percentage >= 50:
		get_parent().get_node("Sprite").modulate = Color.html("#ff8282")
	elif percentage >= 25:
		get_parent().get_node("Sprite").modulate = Color.html("#ff5252")
	elif percentage >= 1:
		get_parent().get_node("Sprite").modulate = Color.html("#ff2121")

func _on_hurtbox_enemy_knockback(knockback_vector):
	velocity = knockback_vector
	set_physics_process(true)  # Activa el proceso de física para aplicar knockback

	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = knockback_duration
	timer.timeout.connect(_end_knockback)
	add_child(timer)
	timer.start()
