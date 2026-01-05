extends CharacterBody2D

@export var ki_bar: Control

@onready var rotation_node: Node2D = $rotationNode
@onready var animated_sprite_2d: AnimatedSprite2D = $rotationNode/AnimatedSprite2D
@onready var hit_box: HitBox = $rotationNode/HitBox

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

var onAction = false

func _ready() -> void:
	add_to_group("player")
	
	hit_box.set_active(false)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_pressed("ui_down") and Input.is_action_pressed("cross"):
		_collect_ki()
	elif Input.is_action_just_pressed("cross"):
		_do_punch()
	elif Input.is_action_just_pressed("circle"):
		_do_kick()

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if onAction: 
		move_and_slide()
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

func _do_punch():
	if onAction: return
	
	onAction = true

	hit_box.set_active(true)
	animated_sprite_2d.play("punch")
	
func _do_kick():
	if onAction: return
	
	onAction = true
	
	hit_box.set_active(true)
	animated_sprite_2d.play("kick")

func _collect_ki():
	onAction = true
	
	ki_bar.get_ki(0.5)
	
	animated_sprite_2d.play("collect_energy")

func _set_animation():	
	if velocity.x > 0:
		rotation_node.scale.x = 1
	elif velocity.x < 0: 
		rotation_node.scale.x = -1
	
	if velocity.x:
		animated_sprite_2d.play("move_forward")
	else:
		animated_sprite_2d.play("idle")	

func _on_animated_sprite_2d_animation_finished() -> void:
	onAction = false
	hit_box.set_active(false)


func _on_hit_box_damage_done() -> void:
	ki_bar.get_ki(10)
