extends CharacterBody2D

@export var jump_velocity: float = -500
@export var slide_velocity: float = 200
@export var ground_pound_velocity: float = 800
@export var move_speed: float = 200
@export var wall_jump_velocity: Vector2 = Vector2(400, -600)
@export var wall_slide_speed: float = 60
@export var wall_stick_time: float = 0.2
@export var max_slide_speed: float = 600
@export var slide_boost_increment: float = 200
@export var spring_jump_horizontal_boost: float = 300
@export var spring_jump_vertical_boost: float = 200

var is_sliding: bool = false
var jump_count: int = 0
var wall_stick_timer: float = 0
var is_wall_sliding: bool = false
var slide_boost_count: int = 0
var has_double_jump: bool = false
var jump_height_level: int = 0
var magnet_level: int = 0
var ground_pound_damage_level: int = 0
var fire_ring_level: int = 0
var has_moustache: bool = false
var is_on_rope: bool = false
var rope_ready: bool = false

@onready var camera: Camera2D = $Camera2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var splash_area: Area2D = $splashArea

var is_facing_right: bool = true
var current_animation: String = "idle"

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	handle_input(delta)
	handle_slide_and_ground_pound()
	handle_wall_interactions(delta)
	handle_camera(delta)
	update_animation()
	move_and_slide()

func handle_input(delta: float) -> void:
	var input_dir = Input.get_axis("left", "right")
	
	if is_on_floor():
		velocity.x = move_toward(velocity.x, input_dir * move_speed, move_speed * delta * 10)
	else:
		velocity.x = move_toward(velocity.x, input_dir * move_speed, move_speed * delta * 5)

	if input_dir != 0:
		is_facing_right = input_dir > 0
		animated_sprite.flip_h = not is_facing_right
		current_animation = "run"
	elif is_on_floor():
		current_animation = "idle"

	if Input.is_action_just_pressed("jump"):
		if is_on_floor() and jump_count == 0:
			jump()
		elif is_wall_sliding:
			wall_jump()
		elif jump_count == 1 and has_double_jump:
			double_jump()

func handle_wall_interactions(delta: float) -> void:
	is_wall_sliding = is_on_wall_only()

	if not is_on_floor():
		velocity.y += gravity * delta

	if is_wall_sliding:
		velocity.y = min(velocity.y, wall_slide_speed)
		wall_stick_timer = wall_stick_time
		current_animation = "wallJump"
	elif is_on_wall() and wall_stick_timer > 0:
		velocity.y = 0
		wall_stick_timer -= delta

	if is_on_floor():
		jump_count = 0
		wall_stick_timer = 0

func jump():
	velocity.y = jump_velocity
	current_animation = "jump"
	jump_count += 1

func double_jump():
	velocity.y = jump_velocity * 0.8
	current_animation = "double_jump"
	jump_count += 1

func wall_jump():
	velocity = wall_jump_velocity
	velocity.x *= -1 if is_facing_right else 1
	is_facing_right = not is_facing_right
	animated_sprite.flip_h = not is_facing_right
	current_animation = "jump"
	jump_count = 1

func handle_slide_and_ground_pound() -> void:
	if Input.is_action_pressed("down"):
		if is_on_floor():
			is_sliding = true
			velocity.x = min(velocity.x + slide_boost_increment * slide_boost_count, max_slide_speed) * (1 if is_facing_right else -1)
			current_animation = "slide"
			slide_boost_count += 1
		else:
			velocity.y = ground_pound_velocity
			current_animation = "ground_pound"
	elif Input.is_action_just_released("down"):
		slide_boost_count = 0
	
	if is_on_floor() and is_sliding:
		is_sliding = false
		velocity.x += 100
		create_splash_damage()

func handle_camera(delta: float) -> void:
	if is_on_floor():
		camera.offset.x = lerp(camera.offset.x, velocity.x * 1, delta)
		camera.offset.y = lerp(camera.offset.y, 0.0, delta)
	else:
		camera.offset.y = lerp(camera.offset.y, velocity.y * -1, delta)

func create_splash_damage() -> void:
	splash_area.global_position = global_position
	splash_area.activate()

func update_animation() -> void:
	if not is_on_floor() and velocity.y > 0:
		current_animation = "fall"
	
	if animated_sprite.animation != current_animation:
		animated_sprite.play(current_animation)
func handle_rope_interaction() -> void:
	if is_on_rope:
		if Input.is_action_pressed("up"):
			velocity.y = -move_speed
		elif Input.is_action_pressed("down"):
			velocity.y = move_speed
		else:
			velocity.y = 0
		
		velocity.x = 0
		current_animation = "climb"
	elif rope_ready and Input.is_action_just_pressed("interact"):
		is_on_rope = true
		velocity = Vector2.ZERO
		global_position.x = get_closest_rope_position()

func get_closest_rope_position() -> float:
	# Implement logic to find the closest rope position
	# This is a placeholder and should be replaced with actual implementation
	return global_position.x

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and is_on_rope:
		is_on_rope = false
		rope_ready = false
