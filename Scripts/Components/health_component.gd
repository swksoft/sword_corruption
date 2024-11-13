extends Node
class_name HealthComponent

signal die

@export var max_health: float = 5
@export var knockback_duration: float = 0.5

var velocity: Vector2 = Vector2.ZERO  
var current_health: float

var invulnerable: bool = false
var invulnerability_duration: float = 0.35  # Tiempo de invulnerabilidad en segundos
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
	$"../AnimationPlayer".play("invulnerability")
	
	if current_health <= 0:
		die.emit()

func _physics_process(delta):
	if velocity.length() > 0:
		get_parent().position += velocity * delta  # Aplica el knockback en cada frame de física
		velocity = velocity.lerp(Vector2.ZERO, delta * 3)  # Reduce gradualmente la velocidad

func _end_knockback(): # FIXME: a
	velocity = Vector2.ZERO
	set_physics_process(false)

	if has_node("../"):
		pass
		#get_parent().get_node("../").set_disabled(false)

func _on_invulnerability_timeout():
	invulnerable = false
	$"../AnimationPlayer".play("RESET")

func _on_hurtbox_player_knockback(knockback_vector):
	velocity = knockback_vector
	set_physics_process(true)  # Activa el proceso de física para aplicar knockback

	if has_node("../"):  # Ajusta el path según tu estructura
		pass
		#get_parent().get_node("../").set_disabled(true)

	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = knockback_duration
	timer.timeout.connect(_end_knockback)
	add_child(timer)
	timer.start()
