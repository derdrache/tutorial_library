extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var rotation_node: Node2D = $rotationNode
@onready var side_climb_ray_cast_1: RayCast2D = $rotationNode/sideClimbRayCast1
@onready var side_climb_ray_cast_2: RayCast2D = $rotationNode/sideClimbRayCast2


const WALK_SPEED = 150
const CLIMB_SPEED = WALK_SPEED / 2
const JUMP_VELOCITY = -250.0

enum STATES {WALK, WALL}
var state = STATES.WALK

func _physics_process(delta: float) -> void:
	if state == STATES.WALK: walk_state(delta)
	else: wall_state(delta)
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction < 0:
		rotation_node.scale.x = -1
	elif direction > 0:
		rotation_node.scale.x = 1

	move_and_slide()

func walk_state(delta):
	if _can_wall_climb(): state = STATES.WALL
	
	if not is_on_floor(): velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * WALK_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
		
	if velocity:
		if velocity.x: 
			animated_sprite_2d.flip_h = velocity.x < 0
			animated_sprite_2d.play("walk")
	else: animated_sprite_2d.play("idle")

func wall_state(delta):
	if not _can_wall_climb(): 
		state = STATES.WALK
		return
	
	velocity = Vector2.ZERO
	
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY 
		state = STATES.WALK
		return
		
	var direction := Input.get_axis("ui_up", "ui_down")

	if direction:
		velocity.y = direction * CLIMB_SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, WALK_SPEED)
	
	animated_sprite_2d.play("climb_wall")
	
	if not velocity.y: animated_sprite_2d.stop()
	
func _can_wall_climb():
	var sideClimbColliding = side_climb_ray_cast_1.is_colliding() or side_climb_ray_cast_2.is_colliding()
	
	if is_on_wall_only() and sideClimbColliding: 	
		return true
	
	
	
	
	
	
	
	
	
	
	
	
