extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_timer: Timer = $interactionTimer

const SPEED = 100.0

var lastDirection: Vector2
var currentCollider: Node2D

func _physics_process(_delta: float) -> void:
	
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	var isColliding = move_and_slide()
	
	if isColliding and direction:
		if interaction_timer.is_stopped():
			interaction_timer.start()
		currentCollider = get_last_slide_collision().get_collider()
	else:
		interaction_timer.stop()

	_set_animation(direction)
	
	lastDirection = direction

func _set_animation(direction):
	if direction.x > 0:
		animated_sprite_2d.flip_h = false
	elif direction.x < 0:
		animated_sprite_2d.flip_h = true

	if interaction_timer.time_left:
		if direction.y > 0:
			animated_sprite_2d.play("interaction_down")
		elif direction.y < 0:
			animated_sprite_2d.play("interaction_up")
		elif direction.x != 0:
			animated_sprite_2d.play("interaction_side")
	elif direction:
		if direction.y > 0:
			animated_sprite_2d.play("walk_down")
		elif direction.y < 0:
			animated_sprite_2d.play("walkd_up")
		elif direction.x != 0:
			animated_sprite_2d.play("walk_side")
	else:
		if lastDirection.y > 0:
			animated_sprite_2d.play("idle_down")
		elif lastDirection.y < 0:
			animated_sprite_2d.play("idle_up")
		elif lastDirection.x != 0:
			animated_sprite_2d.play("idle_side")

func _on_interaction_timer_timeout() -> void:
	if currentCollider is Block:
		currentCollider.push_block(lastDirection)
		
		
	
