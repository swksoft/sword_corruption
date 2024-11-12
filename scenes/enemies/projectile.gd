extends HitboxComponent
class_name Projectile

@export var speed = 150

var direction : Vector2

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_despawn_timeout():
	queue_free()
