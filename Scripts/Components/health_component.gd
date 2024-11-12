extends Node
class_name HealthComponent

signal die

@export var max_health: float = 5
@export var knockback_duration: float = 0.5

var velocity: Vector2 = Vector2.ZERO  
var current_health: float

@onready var timer = $Timer

func _ready():
	current_health = max_health

func _on_hurtbox_component_hit_detected(damage):
	print_debug("Salud ", current_health, " - ", damage)
	current_health -= damage
	print_debug(current_health)
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
		get_parent().get_node("../").set_disabled(false)
		

func _on_hurtbox_player_knockback(knockback_vector):
	velocity = knockback_vector
	set_physics_process(true)  # Activa el proceso de física para aplicar knockback

	if has_node("../"):  # Ajusta el path según tu estructura
		get_parent().get_node("../").set_disabled(true)

	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = knockback_duration
	timer.timeout.connect(_end_knockback)
	add_child(timer)
	timer.start()
