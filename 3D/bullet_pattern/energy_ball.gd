extends CharacterBody3D

var speed = 10
var direction: Vector3

func _physics_process(_delta: float) -> void:
	if not direction:
		return 
		
	velocity = direction * speed

	move_and_slide()

	if get_last_slide_collision():
		queue_free()
