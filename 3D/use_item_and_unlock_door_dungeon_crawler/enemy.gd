extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $Barbarian/AnimationPlayer
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var attack_timer: Timer = $AttackTimer
@onready var damage_indicator: Node3D = $DamageIndicator

const TILE_BLOCKER = preload("uid://bmvnh7cwbp0ud")
const TILE_SIZE = 4.0

var target: Node3D
var onMove = false
var animationSpeed = 0.7
var onAttack = false

var health = 20
var damage = 7

func _ready() -> void:
	add_to_group("enemy")

func _process(_delta: float) -> void:
	if onAttack:
		return
		
	_set_animation()

func _set_animation():
	if onMove:
		animation_player.play("Walking_A")
	else:
		animation_player.play("Idle")

func _physics_process(_delta: float) -> void:
	if not target or onMove:
		return
	
	var collideWithPlayer = ray_cast_3d.is_colliding() and ray_cast_3d.get_collider().is_in_group("player")
	var canAttack = attack_timer.time_left == 0 and not onAttack

	if collideWithPlayer and canAttack:
		_attack()
	elif not ray_cast_3d.is_colliding():
		_move_to_target()

func _attack():
	onAttack = true

	animation_player.play("2H_Melee_Attack_Slice")
	await animation_player.animation_finished
	
	var player = ray_cast_3d.get_collider()
	player.get_damage(damage)
	
	attack_timer.start()
	onAttack = false

func _move_to_target():
	navigation_agent_3d.target_position = target.global_position
	
	var direction = to_local(navigation_agent_3d.get_next_path_position()).normalized().round()

	if direction.z == 1:
		_move_forward()
	elif direction.x:
		_turn(direction.x)

func _move_forward():	
	onMove = true
	
	var targetPosition = global_position + global_basis.z * TILE_SIZE
	
	var tileBlocker = TILE_BLOCKER.instantiate()
	get_tree().current_scene.add_child(tileBlocker)
	tileBlocker.global_position = targetPosition
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", targetPosition, animationSpeed)
	await tween.finished
	
	tileBlocker.queue_free()
	
	onMove = false

func _turn(turnMovement):
	onMove = true
	
	var targetRotation = rotation_degrees
	targetRotation.y += turnMovement * 90
	
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", targetRotation, animationSpeed)
	await tween.finished
	
	onMove = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		target = body

func get_damage(damageValue: int):
	health -= damageValue
	damage_indicator.create_indicator_label(-damageValue)
	
	if health <= 0:
		set_process(false)
		set_physics_process(false)
		animation_player.play("Death_A")
		
		await animation_player.animation_finished
		
		queue_free()
