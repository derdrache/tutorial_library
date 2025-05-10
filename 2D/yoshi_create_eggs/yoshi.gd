extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var rotation_node: Node2D = $RotationNode
@onready var ray_cast_2d: RayCast2D = $RotationNode/RayCast2D

@onready var egg_spawn_position: Marker2D = %EggSpawnPosition
@onready var egg_end_point: Marker2D = %eggEndPoint
@onready var egg_container: Node2D = %eggContainer

const SPEED = 150.0
const EGG = preload("res://yoshis_island/create_egg/egg.tscn")

var JUMP_VELOCITY = -400.0
var activeTongue = false
var tongueForward = true
var tongueAnimation = "tongue"
var tongueLength = 16
var fullMouth = false
var createEgg = false

func _physics_process(delta: float) -> void:
	var speed = SPEED
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if createEgg:
		return
		
	if fullMouth and Input.is_action_just_pressed("ui_down"):
		_create_egg()
		return
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("circle"):
		if fullMouth:
			pass
		else:
			activeTongue = true
			animated_sprite_2d.play(tongueAnimation)
			ray_cast_2d.enabled = true
		return

	if ray_cast_2d.is_colliding() and tongueForward:
		var collider = ray_cast_2d.get_collider()
		
		if collider in get_tree().get_nodes_in_group("enemy"):
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

func _create_egg():
	fullMouth = false
	createEgg = true
	
	animated_sprite_2d.play("create_egg")
	await animated_sprite_2d.animation_finished
	createEgg = false
	
	var newEgg = EGG.instantiate()
	egg_container.add_child(newEgg)
	newEgg.global_position = egg_end_point.global_position
