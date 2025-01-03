extends CharacterBody3D

@export var speed = 10

func _ready():
	velocity.z = -speed


func _physics_process(delta):
	move_and_slide()
