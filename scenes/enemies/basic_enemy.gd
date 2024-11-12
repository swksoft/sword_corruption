class_name Enemy extends CharacterBody2D

@export var health_component : HealthComponent
@export var hurtbox_component : HurtboxComponent

func _on_health_component_die():
	POINTS.emit_add_points(50)
	queue_free()
