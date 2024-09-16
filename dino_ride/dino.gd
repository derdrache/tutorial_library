extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var rider_container: Node2D = $RiderContainer
@onready var rider_position: Marker2D = $RiderPosition

const SPEED = 100.0
const JUMP_VELOCITY = -250.0

var inUse = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("interaction") && inUse: _dismount()
	
	if not inUse: 
		animated_sprite_2d.play("idle")
		return
	
	if not is_on_floor(): velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	_set_animation()
	
	move_and_slide()

func _set_animation():
	if velocity.x: 
		animated_sprite_2d.flip_h = velocity.x < 0
		rider_container.scale.x = -1 if velocity.x < 0 else 1
	
	if velocity: animated_sprite_2d.play("run")
	else: animated_sprite_2d.play("idle")
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.inUse = false
		body.animated_sprite_2d.flip_h = animated_sprite_2d.flip_h
		call_deferred("do_ride", body)

func do_ride(rider):
	rider.reparent(rider_container)
	rider.global_position = rider_position.global_position
	inUse = true

func _dismount():
	inUse = false
	
	animated_sprite_2d.flip_h = false
	rider_container.scale.x = 1
	
	var player = rider_container.get_children()[0]
	player.reparent(get_tree().current_scene)
	player.inUse = true
	
	player.position.x -= 25
