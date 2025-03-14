extends Area2D

var enemy_in_area = null  # Stores enemy reference if in area
@onready var audio_player = $SFXAudioPlayerr  # Get AudioStreamPlayer2D node


func _ready() -> void:
	# Connect signals for detecting enemies
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))


func _process(_delta: float) -> void:
	# If Spacebar is pressed and enemy is in area, kill it
	if Input.is_action_just_pressed("ui_select") and enemy_in_area:
		enemy_in_area.die()
		audio_player.play()


func _on_body_entered(body):
	# If an enemy enters, store reference
	if body.name == "Enemy":
		enemy_in_area = body


func _on_body_exited(body):
	# If the enemy leaves, remove reference
	if body == enemy_in_area:
		enemy_in_area = null
