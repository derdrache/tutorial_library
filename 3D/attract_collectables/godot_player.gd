extends CharacterBody3D

@onready var camera: Node3D = $Camera
@onready var model: Node3D = $godot_plushie_animated
@onready var animation_player: AnimationPlayer = $godot_plushie_animated/AnimationPlayer

const SPEED = 2.0
const JUMP_VELOCITY = 4.5

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("ui_right", "ui_left", "ui_down", "ui_up")
	var direction = (camera.get_camera_transform().basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		direction.y = 0
		model.look_at(position + (-direction))
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	_set_animation()

	move_and_slide()

func _set_animation():
	if velocity: animation_player.play("Run")
	else: animation_player.play("Idle")

func _on_attract_collectables_area_area_entered(area: Area3D) -> void:
	if area is Collectable: area.isCollected = true
