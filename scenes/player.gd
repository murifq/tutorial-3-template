extends CharacterBody2D

@export var gravity = 800.0
@export var walk_speed = 200
@export var crouch_speed = 100
@export var jump_speed = -400
@export var max_jumps = 2
@export var dash_speed = 600
@export var dash_duration = 0.4
@export var dash_cooldown = 0.5
@export var dash_input_time = 0.3
@export var attack_duration = 0.5  # Extended attack duration

var jump_count = 0
var is_dashing = false
var is_crouching = false
var is_attacking = false
var attack_time = 0
var dash_time = 0
var last_dash_time = -dash_cooldown
var last_direction = 1  # 1 = right, -1 = left
var dash_press_times = {"left": 0.0, "right": 0.0}

var crouch_collision = load("res://scenes/PlayerCrouching.tres")
var stand_collision = load("res://scenes/PlayerStanding.tres")

# **Set correct transform positions**
var standing_position_offset = Vector2(0, 12.75)
var crouching_position_offset = Vector2(0, 30)


func _ready():
	$CollisionShape2D.shape = stand_collision
	$CollisionShape2D.position = standing_position_offset
	update_animation("idle")


func _physics_process(delta):
	velocity.y += delta * gravity

	if is_on_floor():
		jump_count = 0

	# Handle Attack Duration
	if is_attacking:
		attack_time -= delta
		if attack_time <= 0:
			is_attacking = false

	# Handle Double Jump
	if Input.is_action_just_pressed("ui_up") and jump_count < max_jumps:
		velocity.y = jump_speed
		jump_count += 1
		update_animation("jump")

	var current_time = Time.get_ticks_msec() / 1000.0
	var direction = 0

	# Handle Dash Input
	if Input.is_action_just_pressed("ui_left"):
		if (
			current_time - dash_press_times["left"] < dash_input_time
			and current_time - last_dash_time > dash_cooldown
		):
			is_dashing = true
			dash_time = dash_duration
			last_dash_time = current_time
		dash_press_times["left"] = current_time
	elif Input.is_action_just_pressed("ui_right"):
		if (
			current_time - dash_press_times["right"] < dash_input_time
			and current_time - last_dash_time > dash_cooldown
		):
			is_dashing = true
			dash_time = dash_duration
			last_dash_time = current_time
		dash_press_times["right"] = current_time

	# Handle Attack Animation
	if Input.is_action_just_pressed("ui_accept") and not is_attacking:
		is_attacking = true
		attack_time = attack_duration
		update_animation("attack")
		return  # Prevent other movement updates when attacking

	# Handle Movement Direction
	if Input.is_action_pressed("ui_left"):
		direction = -1
		last_direction = -1

		if jump_count == 0 and !is_crouching:
			update_animation("walk")
		elif jump_count > 0:
			update_animation("jump")
		elif is_crouching:
			update_animation("crouch")
	elif Input.is_action_pressed("ui_right"):
		direction = 1
		last_direction = 1
		if jump_count == 0 and !is_crouching:
			update_animation("walk")
		elif jump_count > 0:
			update_animation("jump")
		elif is_crouching:
			update_animation("crouch")

	else:
		if is_on_floor() and not is_crouching and not is_attacking:
			update_animation("idle")

	# Handle Dashing
	if is_dashing:
		dash_time -= delta
		if dash_time <= 0:
			is_dashing = false  # End dash after duration

	# Handle crouching
	if Input.is_action_pressed("ui_down") and is_on_floor():
		if not is_crouching:
			crouch()
	else:
		if is_crouching:
			stand()

	# Adjust speed based on crouching state
	var speed = dash_speed if is_dashing else (crouch_speed if is_crouching else walk_speed)
	velocity.x = direction * speed

	move_and_slide()


func crouch():
	is_crouching = true
	$CollisionShape2D.shape = crouch_collision
	$CollisionShape2D.position = crouching_position_offset
	update_animation("crouch")


func stand():
	is_crouching = false
	$CollisionShape2D.shape = stand_collision
	$CollisionShape2D.position = standing_position_offset
	update_animation("idle")


func update_animation(state):
	var anim_sprite = $AnimatedSprite2D

	if state == "walk":
		anim_sprite.animation = "walking"
		anim_sprite.flip_h = (last_direction == -1)  # Flip sprite when moving left
	elif state == "idle":
		anim_sprite.animation = "idling"
	elif state == "jump":
		anim_sprite.animation = "jumping"
		anim_sprite.flip_h = (last_direction == -1)
	elif state == "crouch":
		anim_sprite.animation = "crouching"
		anim_sprite.flip_h = (last_direction == -1)
	elif state == "attack":
		anim_sprite.animation = "attacking"
		anim_sprite.flip_h = (last_direction == -1)
		is_attacking = true
		attack_time = attack_duration

	anim_sprite.play()
