extends CharacterBody3D

@export var walk_speed = 50
@export var run_speed = 125
@export var jump_impulse = 100
@export var gravity = 100
@export var mouse_sensitivity = 0.0012
@onready var camera = $Camera3D

var _snap_vector = Vector3.DOWN


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta):
	handle_mouse_input(delta)
	

func _physics_process(delta):
	handle_movement(delta)


func handle_movement(delta):
	var speed = walk_speed
	if Input.is_action_pressed("run"):
		speed = run_speed
	
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_impulse
	
	direction = direction.rotated(Vector3.UP, camera.rotation.y).normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y -= gravity * delta
	print("Position: ", position.y, ", Velocity: ", velocity.y)

	move_and_slide()


func handle_mouse_input(delta):
	var mouse_motion = Input.get_last_mouse_velocity()
	rotation_degrees.x -= mouse_motion.y * mouse_sensitivity
	rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 90.0)
	
	rotation_degrees.y -= mouse_motion.x * mouse_sensitivity
	rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
