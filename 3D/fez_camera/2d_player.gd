extends CharacterBody3D

@onready var pivot: Node3D = $pivot
@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var cameraRotationTarget: Vector3

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"): _change_camera()
	
func _change_camera():
	var newRotation: Vector3 = cameraRotationTarget + Vector3(0,90.0,0)
	
	var tween := get_tree().create_tween()
	tween.tween_property(pivot, "rotation_degrees", newRotation, 0.3)
	
	cameraRotationTarget = newRotation
	
func _physics_process(delta: float) -> void:
	if not is_on_floor(): velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	_set_animation(input_dir)

	move_and_slide()

func _set_animation(input_dir):
	if input_dir.x < 0: animated_sprite_3d.flip_h = true
	elif input_dir.x > 0: animated_sprite_3d.flip_h = false
	
	if velocity: animated_sprite_3d.play("run")
	else: animated_sprite_3d.play("idle")
