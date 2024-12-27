extends CharacterBody2D

@export var aquaContainer : Control

@onready var fish_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED := 100.0

var targetPosition: Vector2
var borderDistance := 10

func _ready() -> void:
	_set_target_position()
	
func _set_target_position() -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	_set_new_target_position()
	
func _set_new_target_position() -> void:
	var boxSize := aquaContainer.get_global_rect()
	var xPosition := randi_range(
		boxSize.position.x + borderDistance, boxSize.position.x + boxSize.size.x - borderDistance)
	var yPosition := randi_range(
		boxSize.position.y + borderDistance, boxSize.position.y + boxSize.size.y - borderDistance)
	
	targetPosition = Vector2(xPosition, yPosition)

func _physics_process(delta: float) -> void:
	var direction := (targetPosition - global_position).normalized()

	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	if global_position.distance_to(targetPosition) < 5: _on_target()
		
	_set_animation()

	move_and_slide()

func _on_target() -> void:
	set_physics_process(false)
	await get_tree().create_timer(1.5).timeout
	
	_set_new_target_position()
	
	set_physics_process(true)
	
func _set_animation() -> void:
	if velocity: fish_sprite.play("move")
	else: fish_sprite.stop()
