extends CharacterBody2D

@onready var SPRITE = $AnimatedSprite2D
@onready var SPAWNPOINT = $"../Marker2D"
@onready var PARTICLES = $CPUParticles2D
var CAN_DASH = true
var SPEED = 500.00
var GRAVITY_OFFSET = 1
const FRICTION = 50
const JUMP_VELOCITY = -600.0
const DASH_SPEED = 3.00
signal on_dash
signal on_death
signal on_respawn

func _ready() -> void:
	respawn()


func handle_gravity_offset():
	if Input.is_action_pressed("down"):
		GRAVITY_OFFSET = 7
	elif Input.is_action_pressed("up"):
		GRAVITY_OFFSET = 0.5
	else:
		GRAVITY_OFFSET = 1

func sprite_stuff():
	if velocity.x < 0:
		SPRITE.flip_h = true
	elif velocity.x > 0:
		SPRITE.flip_h = false

	if is_on_floor():
		if velocity.x != 0:
				SPRITE.animation = "walk"
				SPRITE.play()
		else:
			SPRITE.animation = "default"
			SPRITE.stop()
	else:
		SPRITE.animation = "jump"
		SPRITE.play()
	

func _physics_process(delta: float) -> void:
	
	
	handle_gravity_offset()
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * GRAVITY_OFFSET
	else:
		CAN_DASH = true

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		SPRITE.scale = Vector2(0.2,2)
		velocity.y = JUMP_VELOCITY
		
		
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	var direction := Input.get_axis("left", "right") 
	if direction:
		velocity.x = direction * SPEED 
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
	
	#Dash
	if Input.is_action_just_pressed("dash"):
		if CAN_DASH == true and direction != 0:
			print("Start")
			$Dashtimer.start()
			on_dash.emit()
			SPEED *= DASH_SPEED
			CAN_DASH = false
	
	
	SPRITE.scale.x = move_toward(SPRITE.scale.x, 1, 3*delta)
	SPRITE.scale.y = move_toward(SPRITE.scale.y, 1, 3*delta)

	sprite_stuff()
	move_and_slide()




func die():
	on_death.emit()
	set_physics_process(false)
	SPRITE.visible = false
	PARTICLES.emitting = false
	PARTICLES.restart()
	PARTICLES.emitting = true

	while not Input.is_action_just_pressed("respawn"):
		await get_tree().process_frame
	respawn()


func respawn():
	set_physics_process(true)
	SPRITE.visible = true
	position = SPAWNPOINT.position
	velocity = Vector2.ZERO
	on_respawn.emit()

#timer for the dash
func _on_timer_timeout() -> void:
	print("timer done") 
	SPEED = 500.00


	


func _on_area_2d_body_entered(_body: Node2D) -> void:
	die() # Replace with function body.
