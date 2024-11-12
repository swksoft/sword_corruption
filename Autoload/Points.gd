@icon("res://icons/box_icon1.svg")

extends Node

var total_points : int

signal add_points(amount)

# TODO: ADD POINTS WHEN: BEATING ENEMIES, COLLECTING ITEMS, PASSING LEVELS

func emit_add_points(amount):
	add_points.emit(amount)
