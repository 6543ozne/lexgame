extends CharacterBody2D
@onready var Particles = %CPUParticles2D
@onready var Shake: PhantomCameraNoiseEmitter2D = $PhantomCameraNoiseEmitter2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var health = 100
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var dead = false

func _physics_process(delta: float) -> void:
	animated_sprite_2d.visible = not dead
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if health <= 0:
		print("Character has died!")
		die()
		  # Remove the character from the scene

	velocity.x = lerpf(velocity.x,0, 3*delta)
	animated_sprite_2d.scale.x = lerpf(animated_sprite_2d.scale.x, 1.0, 5 * delta)
	animated_sprite_2d.scale.y = lerpf(animated_sprite_2d.scale.y, 1.0, 5 * delta)
	move_and_slide()

func damage(amount: int, direction: Vector2) -> void:
	Particles.emitting = true
	Shake.emit()
	# Handle taking damage here
	print("Enemy took " + str(amount) + " damage!")
	health -= amount
	# Knockback logic
	$Timer.start()  # Start a timer for knockback duration
	velocity.x = -direction.x * JUMP_VELOCITY * 0.5  # Adjust the knockback strength as needed
	
func die():
	dead = true
	

func _on_timer_timeout() -> void:
	pass


func _on_cpu_particles_2d_finished() -> void:
	if dead:
		queue_free() # Replace with function body.
		
func bounce(bounce_force) -> void:
	velocity.y = bounce_force
	animated_sprite_2d.scale = Vector2(0.3, 1.8)
