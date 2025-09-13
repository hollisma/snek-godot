extends Node

@export var songs: Array[AudioStream]
@export var default_song: AudioStream = preload("res://music/Running.ogg")

@onready var music_player: AudioStreamPlayer = $MusicPlayer

var current_track: AudioStream = default_song

func start(): 
	current_track.loop = true
	music_player.stream = current_track
	music_player.play()

func play_song(song: AudioStream): 
	if song != current_track: 
		song.loop = true
		current_track = song
		music_player.stream = current_track
		music_player.play()

func play_random_song(): 
	var new_song = current_track
	while new_song == current_track: 
		new_song = songs.pick_random()
	play_song(new_song)
