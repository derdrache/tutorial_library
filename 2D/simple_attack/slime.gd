extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $slime/AnimationPlayer
@onready var selection_mesh: MeshInstance3D = $selectionMesh
@onready var damage_indicator: Node3D = $DamageIndicator

const SPEED = 3.0

var health := 5
var startPoint: Vector3
var enemy: Node3D

func _ready() -> void:
	add_to_group("enemy")
	
	selection_mesh.hide()
	startPoint = global_position

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var startDistance = global_position.distance_to(startPoint)
	
	if enemy:
		_catch_enemy()
	elif startDistance > 2:
		_go_to_start()
	else:
		velocity.x = 0
		velocity.z = 0

	_set_animation()

	move_and_slide()

func _catch_enemy():
	var direction = global_position.direction_to(enemy.global_position)
	velocity = direction * SPEED
	
	look_at(enemy.global_position, Vector3.UP, true)
	
	var distance = global_position.distance_to(enemy.global_position)
	
	if distance > 20:
		enemy = null

func _go_to_start():
	var direction = global_position.direction_to(startPoint)
	velocity = direction * SPEED

func _set_animation():
	if velocity.x or velocity.z:
		animation_player.play("walk")
	else:
		animation_player.play("idle")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		enemy = body

func set_select(boolean: bool):
	selection_mesh.visible = boolean

func take_damage(value):
	health -= value
	
	damage_indicator.create_indicator_label(-value)
	
	if health <= 0:
		queue_free()
