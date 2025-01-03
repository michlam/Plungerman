extends CharacterBody3D

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_forward"):
		velocity.z -= 1
	if Input.is_action_pressed("move_backward"):
		velocity.z += 1
		
	move_and_slide()
