extends CharacterBody2D

@onready var resource = "res://dialog/test.dialogue"
@onready var SPRITE = $AnimatedSprite2D
@onready var SLASH_SPRITE = $Node2D/Area2D/AnimatedSprite2D2
@onready var dash_timer = $Dashtimer

const BASE_SPEED = 200.0
const DASH_SPEED = 600.0
const JUMP_VELOCITY = -400.0
const FRICTION = 20

var direction: float = 0.0
var jump_requested: bool = false
var dash_requested: bool = false
var can_dash: bool = true
var is_dashing: bool = false
var dash_direction: float = 0.0

signal on_dash


func _unhandled_input(event: InputEvent) -> void:
	# Update directional axis whenever movement keys are pressed or released
	if event.is_action("left") or event.is_action("right"):
		direction = Input.get_axis("left", "right")

	# Discrete triggers using event.is_action_pressed
	if event.is_action_pressed("jump"):
		jump_requested = true

	if event.is_action_pressed("dash"):
		dash_requested = true

	if event.is_action_pressed("strike"):
		$Node2D/Area2D.monitoring = true
		SLASH_SPRITE.play("slash")


func _physics_process(delta: float) -> void:
	# Gravity & Ground state
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		can_dash = true

	# Handle Jump request
	if jump_requested:
		if is_on_floor():
			SPRITE.scale = Vector2(0.3, 1.8)
			velocity.y = JUMP_VELOCITY
		jump_requested = false # Reset flag after processing

	# Handle Dash request
	if dash_requested:
		if can_dash and direction != 0:
			start_dash(direction)
		dash_requested = false # Reset flag after processing

	# Movement calculation
	if is_dashing:
		velocity.x = dash_direction * DASH_SPEED
	elif direction != 0:
		velocity.x = direction * BASE_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)

	# Squash & Stretch recovery
	SPRITE.scale.x = move_toward(SPRITE.scale.x, 1.0, 3 * delta)
	SPRITE.scale.y = move_toward(SPRITE.scale.y, 1.0, 3 * delta)

	sprite_stuff()
	move_and_slide()


func start_dash(dir: float) -> void:
	is_dashing = true
	can_dash = false
	dash_direction = dir
	
	SPRITE.scale = Vector2(2.0, 0.2)
	dash_timer.start()
	on_dash.emit()


func sprite_stuff() -> void:
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
	is_dashing = false


func _on_animated_sprite_2d_2_animation_finished() -> void:
	$Node2D/Area2D.monitoring = false
