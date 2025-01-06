extends CharacterBody3D

@export var speed = 10.0

func setup():
	position = get_parent().position - Vector3(0, 0.5, 0)
	visible = true
	velocity = Vector3.FORWARD * speed


func _physics_process(delta: float) -> void:
	move_and_slide()
