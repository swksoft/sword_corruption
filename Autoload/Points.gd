@icon("res://icons/box_icon1.svg")

extends Node

var point_value = 0

# TODO: ADD POINTS WHEN: BEATING ENEMIES, COLLECTING ITEMS, PASSING LEVELS

func add_points(amount):
	point_value += amount
