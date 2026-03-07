extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

var isAttacking = false
var knockbackForce = 500

func _ready() -> void:
	add_to_group("player")
	
	area_2d.monitoring = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack") and not isAttacking:
		_attack()

func _attack():
	isAttacking = true
	
	animated_sprite_2d.play("attack")
	area_2d.monitoring = true
	
	await animated_sprite_2d.animation_finished
	
	isAttacking = false
	area_2d.monitoring = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if isAttacking: 
		return

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	_set_animation()

	move_and_slide()

func _set_animation():
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.offset.x =0
		area_2d.scale.x = 1
	elif velocity.x <0:
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.offset.x = -14
		area_2d.scale.x = -1
	
	if velocity.x:
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("get_knockback"):
		var knockbackDirection = global_position.direction_to(body.global_position)
		knockbackDirection.y = 0
		body.get_knockback(knockbackDirection, knockbackForce)
