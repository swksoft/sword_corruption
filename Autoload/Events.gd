@icon("res://icons/box_icon1.svg")

extends Node

signal corruption_bar_up(amount)
signal charge_bar_up(amount)
signal corrupt_area
signal freeze_game

func emit_charge_bar_up(amount : float):
	emit_signal("charge_bar_up", amount)

func emit_corruption_bar_up(amount : float):
	emit_signal("corruption_bar_up", amount)

func emit_corrupt_area():
	emit_signal("corruption_area")
	
func emit_freeze_game():
	emit_signal("freeze_game")
