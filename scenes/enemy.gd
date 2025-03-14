extends CharacterBody2D

@export var gravity = 800.0
@export var walk_speed = 200

var last_direction = 1  # 1 = right, -1 = left
var change_direction_time = 0.0
var is_dead = false  # Menandakan apakah enemy sudah mati


func _ready():
	update_animation("walk")
	change_direction_time = randf_range(2.0, 5.0)  # Randomize direction change interval


func _physics_process(delta):
	if is_dead:
		velocity = Vector2.ZERO  # Hentikan pergerakan jika mati
		return

	velocity.y += delta * gravity

	# Randomly change direction at intervals
	change_direction_time -= delta
	if change_direction_time <= 0:
		last_direction = -last_direction  # Flip direction
		change_direction_time = randf_range(2.0, 5.0)  # Reset timer with a new random interval
		update_animation("walk")

	# Set auto-walking speed
	velocity.x = last_direction * walk_speed

	move_and_slide()


func update_animation(state):
	var anim_sprite = $AnimatedSprite2D

	if state == "walk":
		anim_sprite.play("walking")
		anim_sprite.flip_h = (last_direction == -1)  # Flip sprite ketika bergerak ke kiri
	elif state == "death":
		anim_sprite.play("death")

	anim_sprite.play()


func die():
	if is_dead:
		return  # Hindari pemanggilan fungsi berulang kali

	is_dead = true
	update_animation("death")  # Mainkan animasi kematian
	velocity = Vector2.ZERO  # Hentikan pergerakan
	set_physics_process(false)  # Nonaktifkan physics process setelah mati
