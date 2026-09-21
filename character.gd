extends CharacterBody2D
@onready var resource = "res://dialog/test.dialogue"
@onready var SPRITE = $AnimatedSprite2D
@onready var SLASH_SPRITE = $Node2D/Area2D/AnimatedSprite2D2
var CAN_DASH = true
var SPEED = 200.0
const JUMP_VELOCITY = -400.0
const FRICTION = 20
const DASH_SPEED = 3.00
signal on_dash



func _unhandled_input(event: InputEvent) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		CAN_DASH = true

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		SPRITE.scale = Vector2(0.3,1.8)
		velocity.y = JUMP_VELOCITY

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
			SPRITE.scale = Vector2(2,0.2)
			CAN_DASH = false
	
	if Input.is_action_just_pressed("strike"):
		$Node2D/Area2D.monitoring = true
		SLASH_SPRITE.play("slash")



	SPRITE.scale.x = move_toward(SPRITE.scale. x, 1, 3*delta)
	SPRITE.scale.y = move_toward(SPRITE.scale.y, 1, 3*delta)

	sprite_stuff()
	move_and_slide()



func sprite_stuff():
	if velocity.x < 0:
		SPRITE.flip_h = true
		$Node2D.scale.x = -1
	elif velocity.x > 0:
		SPRITE.flip_h = false
		$Node2D.scale.x = 1
	if is_on_floor():
		if velocity.x != 0:
				SPRITE.animation = "Run"
				SPRITE.play()
		else:
			SPRITE.animation = "Idle"
			SPRITE.stop()
	else:
		SPRITE.animation = "Jump"
		SPRITE.play()



func _on_dashtimer_timeout() -> void:
	print("timer done") 
	SPEED = 200.00


func _on_animated_sprite_2d_2_animation_finished() -> void:
	$Node2D/Area2D.monitoring = false
