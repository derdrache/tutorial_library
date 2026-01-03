extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var normal_collision: CollisionShape2D = $normalCollision
@onready var crawl_collision: CollisionShape2D = $crawlCollision
@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

var isCrawling = false

func _ready() -> void:
	crawl_collision.disabled = true
	shape_cast_2d.enabled = false
	
func _physics_process(delta: float) -> void:	
	normal_collision.disabled = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("ui_down"):
		_do_crawl()
	elif isCrawling:
		_stop_crawl()
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if isCrawling: 
			velocity.x /= 2
	
	_set_animation(direction)

	move_and_slide()

func _do_crawl():
	normal_collision.disabled = true
	crawl_collision.disabled = false
	isCrawling = true
	shape_cast_2d.enabled = true

func _stop_crawl():
	if shape_cast_2d.is_colliding():
		_do_crawl()
	else:
		shape_cast_2d.enabled = false
		isCrawling = false

func _set_animation(direction):
	if direction < 0: animated_sprite_2d.flip_h = true
	elif direction > 0: animated_sprite_2d.flip_h = false

	if isCrawling: animated_sprite_2d.play("down")
	elif velocity: animated_sprite_2d.play("move")
	else: animated_sprite_2d.play("idle")
