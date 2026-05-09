extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box: Area2D = $hitBox

const SPEED = 200.0
const JUMP_VELOCITY = -300.0

var isAttacking = false

func _ready() -> void:
	hit_box.monitoring = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("attack") and not isAttacking:
		hit_box.monitoring = true
		isAttacking = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and not isAttacking:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	_set_animation()

	move_and_slide()

func _set_animation():
	if isAttacking:
		animated_sprite_2d.play("punch")
	elif velocity.x > 0:
		animated_sprite_2d.play("move_forward")
	elif velocity.x < 0:
		animated_sprite_2d.play("move_backward")
	else:
		animated_sprite_2d.play("idle")


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "punch":
		isAttacking = false
		hit_box.monitoring = false


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(10)
