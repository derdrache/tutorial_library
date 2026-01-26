extends CharacterBody3D

@onready var model: Node3D = %model
@onready var third_person_camera: Node3D = %thirdPersonCamera

const SPEED = 5.0

func _physics_process(_delta: float) -> void:
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (third_person_camera.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		var targetAngle = atan2(direction.x, direction.z)
		model.rotation.y = lerp_angle(model.rotation.y, targetAngle, 0.1)
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	var upDownDir = Input.get_axis("actionQ", "actionE")
	if upDownDir:
		velocity.y = upDownDir * SPEED
	else:
		velocity.y = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
