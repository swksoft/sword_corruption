extends HitboxComponent

signal jump
signal recovered

func jump_now():
	emit_signal("jump")

func recovered_now():
	emit_signal("recovered")

func corrupt():
	EVENTS.emit_corrupt_area(Vector2i(global_position), false)

# FIXME: EL DAÑO SE SUMA SIN RAZON
