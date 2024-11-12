@icon("res://icons/box_icon1.svg")

extends Node

func play_song(name_song: String):
	$SelectedSong.stream = load(name_song)
	$SelectedSong.playing = true
