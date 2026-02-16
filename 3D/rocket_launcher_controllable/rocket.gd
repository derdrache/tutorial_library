extends CharacterBody3D

signal finished

@onready var rocketbullet_low_001: MeshInstance3D = $rocketbullet_low_001
@onready var camera_3d: Camera3D = $Camera3D
@onready var camera_shake: Node3D = $Camera3D/CameraShake
@onready var explosion_effect: Node3D = $ExplosionEffect

const SPEED = 10.0
var turnSpeed = 0.5

func _ready() -> void:
	camera_3d.current = true

func _physics_process(delta: float) -> void:	
	var rotationY = 0
	var rotationZ = 0
	
	if Input.is_key_pressed(KEY_A):
		global_rotate(transform.basis.y, turnSpeed * delta)
		rotationY = turnSpeed/2
	elif Input.is_key_pressed(KEY_D):
		global_rotate(transform.basis.y, -turnSpeed * delta)
		rotationY = -turnSpeed/2
	if Input.is_key_pressed(KEY_W):
		global_rotate(transform.basis.z, turnSpeed * delta)
		rotationZ = turnSpeed/2
	elif Input.is_key_pressed(KEY_S):
		global_rotate(transform.basis.z, -turnSpeed * delta)
		rotationZ = -turnSpeed/2
	
	rocketbullet_low_001.rotation.y = lerp_angle(rocketbullet_low_001.rotation.y, rotationY, 0.1)
	rocketbullet_low_001.rotation.z = lerp_angle(rocketbullet_low_001.rotation.z, rotationZ, 0.1)
	
	velocity = transform.basis.x * SPEED
	
	var isColliding = move_and_slide()
	
	if isColliding:
		_explode()

func _explode():
	set_physics_process(false)
	rocketbullet_low_001.hide()
	camera_3d.position.x -= 4
	
	camera_shake.start(1)
	explosion_effect.emit = true
	
	await get_tree().create_timer(1).timeout
	
	finished.emit()
	
	queue_free()
