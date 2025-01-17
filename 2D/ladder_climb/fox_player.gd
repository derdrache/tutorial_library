extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ladder_ray_cast: RayCast2D = $LadderRayCast

const WALK_SPEED = 150
const CLIMB_SPEED = WALK_SPEED / 2
const JUMP_VELOCITY = -250.0

func _physics_process(delta: float) -> void:
	var ladderCollider = ladder_ray_cast.get_collider()
	
	if ladderCollider:
		_ladder_climb()
	else:
		_movement(delta)

	move_and_slide()

func _movement(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * WALK_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
	
	if velocity.x < 0: animated_sprite_2d.flip_h = true
	elif velocity.x > 0: animated_sprite_2d.flip_h = false

	if velocity: animated_sprite_2d.play("move")
	else: animated_sprite_2d.play("idle")
	
func _ladder_climb():
	var direction = Vector2.ZERO
	
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	if direction: 
		velocity = direction * WALK_SPEED / 2
		animated_sprite_2d.play("climb")
	else: 
		velocity = Vector2.ZERO
		animated_sprite_2d.stop()
