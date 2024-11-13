extends Area2D
class_name HurtboxComponent

# Señal que se emitirá al detectar un hit
signal hit_detected(damage: int)
signal knockback(knockback_vector : Vector2)

@export var knockback_force : float

# Esta función es llamada cuando el Area2D detecta una colisión
func _on_area_entered(area: Node2D):
	if area is MapEntity:
		area.on_interact()
	if area is Destructible:
		area.destroy()
	if area is HitboxComponent:
		var attacker_position = area.global_position
		apply_knockback(attacker_position)
		print_debug(area)
		emit_signal("hit_detected", area.damage)
	if area is Projectile:
		area.queue_free()
	
func apply_knockback(attacker_position: Vector2):
	var direction = (global_position - attacker_position).normalized()
	var knockback_vector = direction * knockback_force
	emit_signal("knockback", knockback_vector)
