extends CharacterBody3D

@export var speed = 10
var _direction = Vector3(0, 0, -1)

func _physics_process(delta):
	move_and_slide()


func set_direction(direction):
	if direction != Vector3.ZERO:
		_direction = direction
		
	velocity.x = _direction.x * speed
	velocity.z = _direction.z * speed
