extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var egg_container: Node2D = %eggContainer
@onready var rotation_node: Node2D = %rotationNode
@onready var egg_marker: Marker2D = %eggMarker

const MAX_SPEED = 150.0

var JUMP_VELOCITY = -400.0
var lastDirection
var speed = 0.0
var acceleration = 2.0


func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var direction := Input.get_axis("ui_left", "ui_right")

	_calculate_speed(direction)
	lastDirection = direction

	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = 0
		
	_set_animation(direction)

	move_and_slide()
		
func _set_animation(direction):
	if direction < 0: rotation_node.scale.x = 1
	elif direction > 0: rotation_node.scale.x = -1
	
	if is_on_floor():
		if velocity.x != 0:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")
	else:
		if velocity.y < 0:
			animated_sprite_2d.play("jump")
		else:
			animated_sprite_2d.play("fall")

func _calculate_speed(direction: float) -> void:
	if direction == 0:
		speed = 0
	elif lastDirection == direction: 
		speed += acceleration
	else:
		speed = 0

	if speed > MAX_SPEED: speed = MAX_SPEED
