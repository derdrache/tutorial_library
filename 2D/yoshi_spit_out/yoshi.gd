extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var rotation_node: Node2D = $RotationNode
@onready var ray_cast_2d: RayCast2D = $RotationNode/RayCast2D

const SPEED = 150.0

var JUMP_VELOCITY = -400.0
var activeTongue = false
var tongueForward = true
var tongueAnimation = "tongue"
var tongueLength = 16
var fullMouth = false
var swallowedEnemy: CharacterBody2D

func _physics_process(delta: float) -> void:
	var speed = SPEED
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("circle") and not activeTongue and not fullMouth:
		activeTongue = true
		animated_sprite_2d.play(tongueAnimation)
		ray_cast_2d.enabled = true
		return
	elif Input.is_action_just_pressed("circle") and fullMouth:
		_spit_out()

	if ray_cast_2d.is_colliding() and tongueForward:
		var collider = ray_cast_2d.get_collider()
		
		if collider in get_tree().get_nodes_in_group("enemy"):
			swallowedEnemy = collider
			collider.catch(self)
		else:
			tongueAnimation = "tongue_forbidden"
			
		_on_animated_sprite_2d_animation_finished()
		
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	_set_animation(direction)

	move_and_slide()
		
func _set_animation(direction):
	if activeTongue: return
	
	if direction < 0: rotation_node.scale.x = 1
	elif direction > 0: rotation_node.scale.x = -1
	
	if is_on_floor():
		if velocity.x != 0:
			if fullMouth:
				animated_sprite_2d.play("run_full_mouth")
			else:
				animated_sprite_2d.play("run")
		else:
			if fullMouth:
				animated_sprite_2d.play("idle_full_mouth")
			else:
				animated_sprite_2d.play("idle")
	else:
		if velocity.y < 0:
			if fullMouth:
				animated_sprite_2d.play("jump_full_mouth")
			else:
				animated_sprite_2d.play("jump")
		else:
			if fullMouth:
				animated_sprite_2d.play("fall_full_mouth")
			else:
				animated_sprite_2d.play("fall")

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "tongue" and tongueForward:
		var tongueLastFrame = animated_sprite_2d.get_frame()
		tongueForward = false
		animated_sprite_2d.play_backwards(tongueAnimation)
		animated_sprite_2d.set_frame_and_progress(tongueLastFrame, 0.0)
	elif animated_sprite_2d.animation == tongueAnimation:
		tongueForward = true
		activeTongue = false
		ray_cast_2d.enabled = false
		tongueAnimation = "tongue"

func _on_animated_sprite_2d_frame_changed() -> void:	
	if animated_sprite_2d.animation == tongueAnimation:
		ray_cast_2d.target_position.x = -(animated_sprite_2d.frame +1)  * tongueLength

func eat():
	fullMouth = true

func get_direction():
	return animated_sprite_2d.scale.x

func _spit_out():
	fullMouth = false
	swallowedEnemy.global_position = global_position
	swallowedEnemy.global_position.x -= 16 * rotation_node.scale.x
	swallowedEnemy.disable(false)
	var spitDirection = global_position.direction_to(swallowedEnemy.global_position)
	swallowedEnemy.spit_out(spitDirection)
