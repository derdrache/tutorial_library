extends CharacterBody2D

@onready var normal_sprite: Sprite2D = $normalSprite
@onready var inhale_sprite: Sprite2D = $inhaleSprite
@onready var full_sprite: Sprite2D = $fullSprite
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D

const SPEED = 100.0
const JUMP_VELOCITY = -200.0
const INHALE_FACTOR = 0.5

var is_inhale := false
var is_full := false

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("attack") and not is_full: 
		is_inhale = true
		_do_inhale()
	else: 
		is_inhale = false
	
	shape_cast_2d.enabled = is_inhale
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	_set_animation()

	move_and_slide()

func _do_inhale():
	if inhale_sprite.flip_h: shape_cast_2d.target_position.x = -20
	else: shape_cast_2d.target_position.x = 20
	
	if shape_cast_2d.is_colliding():
		var collider = shape_cast_2d.get_collider(0)
		var forceDirection = (global_position - collider.global_position).normalized()
		
		collider.global_position += forceDirection * INHALE_FACTOR

func _set_animation():
	if velocity.x > 0: 
		normal_sprite.flip_h = false
		inhale_sprite.flip_h = false
		full_sprite.flip_h = false
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.offset.x = 0
	elif velocity.x < 0:
		normal_sprite.flip_h = true
		inhale_sprite.flip_h = true
		full_sprite.flip_h = true
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.offset.x = -28
	
	if is_full:
		full_sprite.show()
		inhale_sprite.hide()
		normal_sprite.hide()
		animated_sprite_2d.hide()
	
	elif is_inhale:
		inhale_sprite.show()
		animated_sprite_2d.show()
		normal_sprite.hide()
		full_sprite.hide()
	else:
		normal_sprite.show()
		inhale_sprite.hide()
		animated_sprite_2d.hide()
		full_sprite.hide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Enemy" and is_inhale:
		is_full = true
		body.queue_free()
