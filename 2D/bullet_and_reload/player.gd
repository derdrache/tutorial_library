extends CharacterBody2D

@onready var rotation_node: Node2D = $rotationNode
@onready var bullet_spawn_marker: Marker2D = %BulletSpawnMarker
@onready var bullet_ammo_display: HBoxContainer = $CanvasLayer/bulletAmmoDisplay

const BULLET = preload("res://bullet.tscn")
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const maxBulletCount = 5

var canShoot = true
var bulletCount = maxBulletCount
var ammoCount = 45

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("leftClick") && canShoot && bulletCount > 0:
		shoot()
	
	if Input.is_action_just_pressed("interaction") && ammoCount > 0:
		_reload()
	
	rotation_node.look_at(get_global_mouse_position())
	
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity = direction.normalized() * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func shoot():
	canShoot = false
	bulletCount -= 1
	
	bullet_ammo_display.refresh_bullets(bulletCount)
	
	var bullet = BULLET.instantiate()
	bullet.direction = global_position.direction_to(bullet_spawn_marker.global_position)
	
	get_tree().current_scene.add_child(bullet)
	
	bullet.global_position = bullet_spawn_marker.global_position
	
	await get_tree().create_timer(0.2).timeout
	
	canShoot = true

func _reload():
	var reloadCount = maxBulletCount - bulletCount
	
	if ammoCount >= reloadCount:
		bulletCount += reloadCount
		ammoCount -= reloadCount
	else:
		bulletCount += ammoCount
		ammoCount = 0

	bullet_ammo_display.refresh_bullets(bulletCount)
	bullet_ammo_display.refresh_ammo_count(ammoCount)
		
		
		
		
		
		
		
		
		
		
		
		
		
