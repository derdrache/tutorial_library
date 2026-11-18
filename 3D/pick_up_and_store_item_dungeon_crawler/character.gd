extends CharacterBody3D

@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var animation_player: AnimationPlayer = $Knight/AnimationPlayer
@onready var attack_timer: Timer = $AttackTimer

const TILE_SIZE = 4.0
const TILE_BLOCKER = preload("uid://bmvnh7cwbp0ud")

var onMove = false
var animationSpeed = 0.7
var direction: Vector2
var onAttack = false

var health = 50
var damage = 5

func _ready() -> void:
	add_to_group("player")

func _input(_event: InputEvent) -> void:
	if onMove or onAttack:
		return
	
	if direction.y and not ray_cast_3d.is_colliding():
		_move(direction.y)
	elif direction.x:
		_turn(direction.x)
	
	if onMove:
		animation_player.play("Walking_A")
	else:
		animation_player.play("Idle")
		
func _move(direction):	
	onMove = true
	
	var targetPosition = global_position + -direction * global_basis.z * TILE_SIZE

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
	targetRotation.y -= turnMovement * 90
	
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", targetRotation, animationSpeed)
	await tween.finished
	
	onMove = false

func _physics_process(_delta: float) -> void:
	if onAttack:
		return

	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		ray_cast_3d.target_position.z = -direction.y * TILE_SIZE
	
	if Input.is_action_just_pressed("ui_accept"):
		_attack()

func _attack():
	var collider = ray_cast_3d.get_collider()
	var hasEnemy = collider and collider.is_in_group("enemy")
	
	if onAttack or attack_timer.time_left != 0 or not hasEnemy:
		return
	
	onAttack = true
	
	animation_player.play("1H_Melee_Attack_Slice_Horizontal")
	await animation_player.animation_finished
	
	collider.get_damage(damage)
		
	attack_timer.start()
	onAttack = false

func get_damage(damageValue:int):
	health -= damageValue
