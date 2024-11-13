extends HitboxComponent
class_name Projectile

@export var speed = 150
@export var direction := Vector2.RIGHT

func _physics_process(delta):
	position += direction * speed * delta
	$Sprite.flip_h = direction.x < 0

func _on_despawn_timeout():
	queue_free()

func _on_area_entered(area):
	if area is AreaEvent:
		return
	EVENTS.emit_corrupt_area(Vector2i(global_position), false)
	queue_free()
