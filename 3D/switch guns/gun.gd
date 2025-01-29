@tool
extends Node3D

@export var gunResource: GunResource

@onready var marker_3d: Marker3D = $Marker3D
@onready var shoot_cooldown_timer: Timer = $shootCooldownTimer
@onready var reload_timer: Timer = $reloadTimer

const BULLET_HOLE = preload("res://effects/bulletHole.tscn")
const BULLET_TRAIL = preload("res://effects/bulletTrail.tscn")

var currentBullets = 0
var gunsEquipt : Array[GunResource] = []
var currentGunIndex = 0
var currentGunNode

func _ready() -> void:
	pass # the code is replaced in the "setup_current_gun"

func set_guns(gunList):
	gunsEquipt = gunList
	if not gunsEquipt.is_empty() : 
		gunResource = gunsEquipt[currentGunIndex]
		_setup_current_gun()
		
func _setup_current_gun():
	if not gunResource: return
	
	if currentGunNode: remove_child(currentGunNode)
	
	currentGunNode = gunResource.model.instantiate()
	add_child(currentGunNode)
	marker_3d.position = gunResource.bulletSpawnOffset
	shoot_cooldown_timer.wait_time = gunResource.shootCooldown
	reload_timer.wait_time = gunResource.reloadTime
	currentBullets = gunResource.reload_count()	
	
func next_gun():
	currentGunIndex += 1
	if currentGunIndex > gunsEquipt.size() - 1:
		currentGunIndex = 0
	
	gunResource = gunsEquipt[currentGunIndex]
	_setup_current_gun()

func previuos_gun():
	currentGunIndex -= 1
	if currentGunIndex < 0:
		currentGunIndex = gunsEquipt.size() - 1

	gunResource = gunsEquipt[currentGunIndex]
	_setup_current_gun()

func get_damage_value():
	return gunResource.damage

func get_bullet_spawn_point():
	return marker_3d.global_position

func shoot(rayCast, targetPosition):
	if shoot_cooldown_timer.time_left or reload_timer.time_left: return
	
	currentBullets -= 1
	_create_bullet_trail(targetPosition)
	
	if not rayCast.is_colliding(): return
	
	var collider = rayCast.get_collider()
	
	if collider.is_in_group("enemy"): 
		var damage = get_damage_value()
		collider.do_damage(damage)
	
	_create_bullet_hole(rayCast)
	
	if currentBullets == 0:
		reload()
	else:
		shoot_cooldown_timer.start()

func _create_bullet_trail(targetPosition):
	var bulletTrailNode = BULLET_TRAIL.instantiate()
	
	get_tree().current_scene.add_child(bulletTrailNode)
	bulletTrailNode.global_position = get_bullet_spawn_point()
	
	var bulletDirection = bulletTrailNode.global_position.direction_to(targetPosition)
	bulletTrailNode.set_direction(bulletDirection)
	bulletTrailNode.look_at(bulletTrailNode.global_position + bulletDirection, Vector3.UP)

func _create_bullet_hole(rayCast):
	var bulletHoleNode = BULLET_HOLE.instantiate()
	rayCast.get_collider().add_child(bulletHoleNode)
	bulletHoleNode.global_position = rayCast.get_collision_point()
	bulletHoleNode.look_at(bulletHoleNode.global_position + rayCast.get_collision_normal(), Vector3.UP)
	
func reload():
	reload_timer.start()
	currentBullets = gunResource.reload_count()
	
	_simple_reload_animation()
	
func _simple_reload_animation():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees", rotation_degrees + Vector3(75,0,0) ,gunResource.reloadTime/3)
	await tween.finished
	await get_tree().create_timer(gunResource.reloadTime/3).timeout
	
	tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees", rotation_degrees + Vector3(-75,0,0) ,gunResource.reloadTime/3)


	
	
	
