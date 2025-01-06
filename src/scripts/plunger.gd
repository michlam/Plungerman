extends CharacterBody3D

@export var speed = 10.0

func setup():
	position = Vector3(0, 0, 0)
	visible = true
	
	var new_basis = get_parent().global_transform.basis
	new_basis.x *= -abs(new_basis.x)
	new_basis.y = -abs(new_basis.y)
	print(new_basis)
	velocity = Vector3.FORWARD * new_basis * speed


func _physics_process(delta: float) -> void:
	move_and_slide()
