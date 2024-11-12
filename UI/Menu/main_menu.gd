extends Control

func _ready():
	BGM.play_song("res://Music/Grind.ogg")



func _on_btn_play_pressed():
	BGM.play_song("res://Music/Admin Rights.ogg")
	get_tree().change_scene_to_file("res://scenes/tests/world_test.tscn")
