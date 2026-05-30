extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box: Area2D = $hitBox

enum AttackTypes {PUNCH, JUMP_KICK}

const SPEED = 200.0
const JUMP_VELOCITY = -300.0

var isAttacking = false
var attackTyp: AttackTypes

func _ready() -> void:
	hit_box.monitoring = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if isAttacking and attackTyp == AttackTypes.JUMP_KICK and is_on_floor():
		isAttacking = false
		hit_box.monitoring = false

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("attack") and not isAttacking:
		hit_box.monitoring = true
		isAttacking = true

		if not is_on_floor():
			attackTyp = AttackTypes.JUMP_KICK
		else:
			attackTyp = AttackTypes.PUNCH

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and (not isAttacking or attackTyp == AttackTypes.JUMP_KICK):
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	_set_animation()

	move_and_slide()

func _set_animation():
	if isAttacking:
		match attackTyp:
			AttackTypes.PUNCH: animated_sprite_2d.play("punch")
			AttackTypes.JUMP_KICK: animated_sprite_2d.play("jump_kick")
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
