@icon("res://icons/box_icon1.svg")

extends Node

signal corruption_bar_up(amount)
signal charge_bar_up(amount)
signal corrupt_time(level)
signal corrupt_area(coords, large_area)
signal freeze_game
signal hud_ready
signal end_level

func emit_charge_bar_up(amount : float):
	emit_signal("charge_bar_up", amount)

func emit_corruption_bar_up():
	emit_signal("corruption_bar_up")
	
func emit_freeze_game():
	emit_signal("freeze_game")

func emit_hud_ready():
	emit_signal("hud_ready")

func emit_corrupt_time(level):
	emit_signal("corrupt_time", level)

func emit_corrupt_area(coords, large_area= false):
	emit_signal("corrupt_area", coords, large_area)

func emit_end_level():
	emit_signal("end_level")
