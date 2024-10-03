extends CharacterBody2D

# Declare variables
var jumpVelocity = -500
var slideVelocity = 200
var groundPoundVelocity = -800
var isSliding = false
var jumpCount = 0
var splashArea: Area2D

# Animation handling
var animation_to_play: String = ""

# Camera settings
var camera: Camera2D

func _ready():
	splashArea = $splashArea  # Assuming SplashArea is a child node of the player
	camera = $Camera2D  # Assuming Camera2D is a child node of the player

# Process movement
func _physics_process(delta):
	handle_jump(delta)
	handle_slide(delta)
	handle_camera(delta)
	update_animation()
	# Update player position
	move_and_slide()

# Handle Jump
func handle_jump(delta):
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() and jumpCount == 0:
			velocity.y = jumpVelocity
			animation_to_play = "jump"
			jumpCount = 1
		elif jumpCount == 1:  # Handle double jump
			velocity.y = jumpVelocity * 2
			animation_to_play = "doubleJump"
			jumpCount = 2

# Handle Slide and Ground Pound
func handle_slide(delta):
	if Input.is_action_pressed("down"):
		if is_on_floor():
			isSliding = true
			velocity.x = slideVelocity * (1 if is_facing_right() else -1)  # Slide direction based on facing
			animation_to_play = "slide"  # Add slide animation
		else:
			velocity.y += get_gravity() * delta  # Ground pound effect
			animation_to_play = "groundPound"  # Add ground pound animation
			
	if is_on_floor() and isSliding:
		isSliding = false
		velocity.x += 100  # Accelerate on landing from slide
		create_splash_damage()

	# Reset jump count and velocity
	if is_on_floor():
		jumpCount = 0
		if not isSliding:
			velocity.y = 0  # Reset vertical velocity



# Handle Camera Dynamics
func handle_camera(delta):
	if is_on_floor():
		camera.offset.x = lerp(camera.offset.x, velocity.x * 0.1, delta)
		camera.offset.y = lerp(camera.offset.y, 0, delta)  # Center the camera vertically
	else:
		camera.offset.y = lerp(camera.offset.y, velocity.y * -0.1, delta)  # Adjust for jump/fall

# Create Splash Damage
func create_splash_damage():
	splashArea.position = position  # Position the splash area at the character's position
	splashArea.queue_free()  # Reset the splash area (this assumes you will recreate it when needed)

# Update Animation State
func update_animation():
	if animation_to_play != "":
		# Play the current animation (assuming you have an AnimationPlayer node)
		$AnimationPlayer.play(animation_to_play)
		animation_to_play = ""  # Reset after playing
