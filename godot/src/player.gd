extends CharacterBody2D

# Animated sprite child node
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Properties
@export var speed = 250.0
@export var jumpVelocity = -400.0
var animation_to_play = "idle"
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var jumpCount : float = 0

# Start front idle animation on load
func _ready():
	animated_sprite_2d.stop()
	animated_sprite_2d.play("idle")

func _physics_process(delta):
	print(velocity.y * delta)
	animation_to_play = "" + ("run" if velocity.x > 0.0 or velocity.x < 0 else "idle")
	
	# Add velocity depending on button press
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	# Handle sprite flip
	if Input.is_action_just_pressed("left"):
		animated_sprite_2d.flip_h = true
	if Input.is_action_just_pressed("right"):
		animated_sprite_2d.flip_h = false
		
	if is_on_floor() or is_on_wall():
		jumpCount = 0
	# Handle Jump
	if Input.is_action_just_pressed("jump") and is_on_floor() and jumpCount == 0:
		velocity.y = jumpVelocity
		animation_to_play = "jump"
		Input.action_release("ui_accept")
		jumpCount = 1
		
		# Handle double jump
		if Input.is_action_just_pressed("jump") and not is_on_floor() and jumpCount == 1:
			
			velocity.y = jumpVelocity * 2
			jumpCount = 2
			while not is_on_floor(): 
				animation_to_play = "doubleJump"
	# Reset velocity
	if not is_on_floor() and jumpCount != 2:
		velocity += get_gravity() * delta
		animation_to_play = "fall"
		
			
		
	# All movement animations named appropriately
	animated_sprite_2d.play(animation_to_play)
	
	# Move character, slide at collision
	move_and_slide()
