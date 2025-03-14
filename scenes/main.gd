extends Node2D

var main_music = preload("res://assets/audio/main_music.wav")
var combat_music = preload("res://assets/audio/combat_music.wav")

@onready var player = $Player
@onready var enemy = $Enemy
@onready var audio_player = $AudioStreamPlayer2D

var combat_distance = 300  # Adjust this threshold as needed


func _process(delta):
	if player and enemy:
		var distance = player.global_position.distance_to(enemy.global_position)
		if distance < combat_distance:
			play_music(combat_music)
		else:
			play_music(main_music)


func play_music(music):
	if audio_player.stream != music:
		audio_player.stream = music
		audio_player.play()
