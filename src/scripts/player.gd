extends CharacterBody3D

@export var walk_speed = 2
@export var run_speed = 5
@export var jump_impulse = 10
@export var pull_impulse = 60
@export var max_air_speed = 60
@export var gravity = 20
@export var mouse_sensitivity = 0.002
@onready var camera = $Camera3D

const PLUNGER_SCENE = preload("res://src/scenes/plunger.tscn")
var plunger;
var rope;

var direction = Vector3.ZERO


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta):
	handle_mouse_input()
	handle_plunger_input()
	handle_plunger_rope()
	

func _physics_process(delta):
	handle_movement(delta)
	handle_pull_input()
	

func line(pos1, pos2, color) -> MeshInstance3D:
	var mesh_instance = MeshInstance3D.new()
	var immediate_mesh = ImmediateMesh.new()
	var material = ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = false
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	
	return mesh_instance


func handle_plunger_rope():
	if rope:
		rope.queue_free()
		rope = line(plunger.global_position, global_position, Color.BLACK)
		get_tree().get_root().add_child(rope)


func handle_pull_input():
	if Input.is_action_just_pressed("pull"):
		if plunger && plunger.attached:
			var impulse_direction = plunger.position - position
			velocity += (impulse_direction.normalized() * pull_impulse)




func handle_plunger_input():
	if Input.is_action_just_pressed("shoot"):
		plunger = PLUNGER_SCENE.instantiate()
		add_child(plunger)
		plunger.speed = plunger.speed + velocity.length()
		plunger.global_transform = global_transform
		
		rope = line(plunger.global_position, global_position, Color.BLACK)
		get_tree().get_root().add_child(rope)
	
	if Input.is_action_just_released("shoot"):
		plunger.queue_free()
		rope.queue_free()
		plunger = null
		rope = null


# Handles WASD and jump inputs
func handle_movement(delta):
	var speed = walk_speed
	if Input.is_action_pressed("run"):
		speed = run_speed
	
	if is_on_floor():
		direction = Vector3.ZERO
		if Input.is_action_pressed("move_left"):
			direction -= transform.basis.x
		if Input.is_action_pressed("move_right"):
			direction += transform.basis.x
		if Input.is_action_pressed("move_forward"):
			direction -= transform.basis.z
		if Input.is_action_pressed("move_backward"):
			direction += transform.basis.z
		
		direction = direction.normalized()
		
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	
	if !is_on_floor():
		velocity.y -= gravity * delta
		
		if velocity.length() > max_air_speed:
			velocity *= (max_air_speed / velocity.length())
		
		
	else:
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_impulse
		else:
			velocity.y = 0

	move_and_slide()


# Handles camera movement with mouse
func handle_mouse_input():
	var mouse_motion = Input.get_last_mouse_velocity()
	rotation_degrees.x -= mouse_motion.y * mouse_sensitivity
	rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 90.0)
	
	rotation_degrees.y -= mouse_motion.x * mouse_sensitivity
	rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
