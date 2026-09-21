extends CharacterBody2D
@onready var Particles = $CPUParticles2D 
var health = 100
const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if health <= 0:
		print("Character has died!")
		queue_free()  # Remove the character from the scene

	velocity.x = lerpf(velocity.x,0, 3*delta)
	move_and_slide()

func damage(amount: int, direction: Vector2) -> void:
	Particles.emitting = true
	# Handle taking damage here
	print("Enemy took " + str(amount) + " damage!")
	health -= amount
	# Knockback logic
	$Timer.start()  # Start a timer for knockback duration
	velocity.x = -direction.x * JUMP_VELOCITY * 0.5  # Adjust the knockback strength as needed


func _on_timer_timeout() -> void:
	pass
