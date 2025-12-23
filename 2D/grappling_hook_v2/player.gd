extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitBoxCollision: CollisionShape2D = $HitBox/CollisionShape2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hit_box: HitBox = $HitBox
@onready var ray_cast_2d: RayCast2D = $RayCast2D

const GRAPPLING_HOOK = preload("uid://xtuvcdwkrsrl")

const SPEED = 150.0
const JUMP_VELOCITY = -325.0

var onAttack = false

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	_set_ray_cast_direction()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("attack"):
		_attack()
	elif Input.is_action_just_pressed("interaction"):
		_use_grappling_hook()
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

func _set_ray_cast_direction():
	var lookDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if lookDirection.y > 0: return
	
	ray_cast_2d.look_at(global_position + lookDirection)

func _attack():
	onAttack = true
	animated_sprite_2d.play("attack")
	
	await animated_sprite_2d.animation_finished
	
	onAttack = false

func _use_grappling_hook():
	if not ray_cast_2d.is_colliding(): return
	
	set_active(false)
	
	animated_sprite_2d.play("idle")
	
	var startOffSet = Vector2(0,-30)
	global_position += startOffSet
	
	var grapplingHookNode = GRAPPLING_HOOK.instantiate()
	get_tree().current_scene.add_child(grapplingHookNode)
	grapplingHookNode.start_hook(ray_cast_2d.get_collision_point())

func set_active(boolean: bool):
	set_physics_process(boolean)
	collision_shape_2d.disabled = not boolean

func _set_animation():
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.offset.x =0
		hit_box.scale.x = 1
	elif velocity.x <0:
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.offset.x = -14
		hit_box.scale.x = -1
	
	if onAttack: return
	
	if velocity.x:
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")

func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite_2d.animation == "attack":
		var frame = animated_sprite_2d.frame
		
		if frame == 1:
			hitBoxCollision.disabled = false
		elif frame == 6:
			hitBoxCollision.disabled = true
