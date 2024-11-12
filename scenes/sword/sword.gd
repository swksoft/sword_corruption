extends HitboxComponent

signal jump
signal recovered

func jump_now():
	emit_signal("jump")

func recovered_now():
	emit_signal("recovered")
