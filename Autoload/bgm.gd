@icon("res://icons/box_icon1.svg")

extends Node

func play_song(name_song: String):
	$SelectedSong.stream = load(name_song)
	$SelectedSong.playing = true

func play_sound(sound: String):
	if sound == null or sound == "":
		return
	
	var player = AudioStreamPlayer.new()
	player.stream = load(sound)
	player.finished.connect(player.queue_free)
	get_tree().get_root().add_child(player)
	player.play()
