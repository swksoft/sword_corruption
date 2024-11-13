class_name AnimationManager extends Node

@export var animation_node : AnimationPlayer

func play_animation(name_animation): animation_node.play(name_animation)

func attack_animation(charge_level):
	if charge_level >= 1.0:
		animation_node.play("slash_4")
	elif charge_level >= 0.5:
		animation_node.play("slash_3")
	elif charge_level >= 0.25:
		animation_node.play("slash_2")
	elif charge_level >= 0:
		animation_node.play("slash")

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"slash", "slash_2", "slash_3", "slash_4":
			#animation_node.play("idle")
			animation_node.play("recovery")
		"recovery":
			animation_node.play("idle")
		"jump":
			animation_node.play("RESET")


